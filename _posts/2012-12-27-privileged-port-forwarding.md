---
layout: post
title: Remote Port Forwarding on Privileged Ports
---

### The problem

I have a web server running on my laptop on a local network. I also have a server running at home attached to a domain ([http://mopsled.com](http://mopsled.com)). I want to be able to give people my domain address, and have their connections be forwarded to my local web server transparently.

### Remote port forwarding with SSH

Fortunately, `ssh` solves most of this problem with remote port forwarding.

{% highlight bash %}
# Forward all connections to mopsled.com:10080 to local port 80
ssh mopsled.com -R 10080:localhost:80
{% endhighlight %}

However, if the remote port forwarding will be in use for a while, I don't want to have to worry about checking the SSH connection and restarting it when necessary. For that, a tool called `autossh` exists.

### Persistent tunneling with autossh

`autossh` wraps normal SSH connections with a few extra flags. The first two flags below are used by autossh, and the rest of the command is called with `ssh` every time `autossh` notices that the connection needs to be restarted.

{% highlight bash %}
autossh -f -M 10081 -R 10080:localhost:80 -N mopsled.com
# autossh flags:
#   -f        run in background
#   -M 10081  monitor SSH connection using port 10081 (any random unused port)
#
# The rest is passed to the ssh command
#
# ssh flags:
#   -R 10080:localhost:80  Forward connections from mopsled:10080 to localhost:80
#   -N                     Don't start a shell
#   mopsled.com            Host
{% endhighlight %}

By running the command above on my laptop, I can create a persistent tunnel between mopsled.com port 10080 and my local web server. However, this is still not enough if I want clients to be able to connect to mopsled.com on the default HTTP port 80, or if I want to remotely tunnel another privileged port.

### Local port redirection using socat

Unfortunately, creating a remote port forward for a privileged port isn't straightforward.

{% highlight bash %}
$ ssh mopsled.com -R 80:localhost:80
Warning: remote port forwarding failed for listen port 80
{% endhighlight %}

This is because port 80 (and all other ports below 1024) are only accessible by root. Although I have `sudo` power on the remote server, I still can't forward port 80 without actually connecting to the server *as* root, which is generally disabled for security reasons.

Fortunately, I found `socat`, a great tool for manipulating sockets on Unix systems. The following command is run on the remote server that the clients will be connecting to.

{% highlight bash %}
# Listen on port 80 and redirect any incoming connections to port 10080 on a new process
sudo socat TCP-LISTEN:80,fork TCP:localhost:10080
{% endhighlight %}

### Wrap up
Using a combination of `autossh` with `ssh`'s remote port forwarding capabilities makes it really easy to set up persistent tunnels. In the event that the remote port needs to be a privileged one, `socat` does a good job of redirecting traffic between local ports.

    client -> mopsled.com:80 -> mopsled.com:10080 -> ssh tunnel -> local port 80
    (and back)

However, as evident from the route above, this solution is really only good for a quick hack, and probably shouldn't be used for anything serious. Although the delay this overhead causes will vary depending on the local and remote connections, I found that my load times were 400-600ms, which is unacceptable for any real web application in production. In any case, this is an interesting exercise of `ssh`'s built-in power mixed in with the utility of `socat` for messing around with local connections.

### Further information

- [The Black Magic of SSH](http://vimeo.com/54505525) - _An presentation and overview of the things you can do with the Secure Shell (SSH), *other* than an actual shell._