---
layout: post
title: Sharing Brew with Non-Administrative Users
---

### Homebrew

[Homebrew](http://mxcl.github.com/homebrew/) is a fantastic package manager for OS X. Homebrew offers a one-line bash install and a lot of sensible defaults (such as installing all packages *without* `sudo` privileges) and generally is a fantastic tool. 

However, installing `brew` onto a new OS X install isn't entirely straightforward, and can cause the inability of multiple users to share the same package space. Here, I'll demonstrate how to install `brew` using groups.

### Install

At the time of writing, the installer for `brew` is this bash one-liner:

{% highlight bash %}
ruby -e "$(curl -fsSkL raw.github.com/mxcl/homebrew/go)"
{% endhighlight %}

After running the script, the installer will prompt for `sudo` privileges in order to create the directory structure under `/usr/local/`. By default, the script will create the `/usr/local/` folder with user `root` and group `admin`. User accounts created in OS X by default are created in the `admin` group. This means that administrative users on the computer will be able to write to `/usr/local/`.

However, it's not very difficult to abstract the responsibility to a new group, so that the ability to use `brew` can be shared among non-administrative users.

### Group setup

Creating a group in OS X isn't very unixy, but is very simple to do.

First, open up the **System Preferences** panel.


![System Preferences panel](/images/sharing-brew/system-preferences-panel.png)

In System Preferences, open the section titled **Users & Groups**.

![Users and groups](/images/sharing-brew/users-and-groups.png)

In the left panel of the **Users & Groups** section, you'll see something like the picture below. Click the **+** button at the bottom of the left-side panel. Note: If the **+** button is not enabled, you will need to click the lock icon below the panel to make changes.

![Users and groups left side panel](/images/sharing-brew/left-panel-plus.png)

Change the first dropdown entitled 'New Account:' from **Standard** to **Group**.

![Menu changed to groups](/images/sharing-brew/menu-change-to-groups.png)

Select a group name for users that can use brew. I chose 'brewers'. Click **Create Group**.

![Brewers groups creation screen](/images/sharing-brew/brewers-group-create.png)

Your group should now be selected in the left side panel, and the group membership options shown in the right panel. Select the members of the group that you'd like to be able to change `brew` packages in the membership panel.

![Brewers group membership](/images/sharing-brew/brewers-membership.png)

### Changing directory permissions

Now, all that's left is to set the `brew` install folder (usually `/usr/local/`, but more generally specified by `brew --prefix`) to allow users in the group `brewers` to change it.

Open up a new terminal (so your new group membership will apply), and type this command:
{% highlight bash %}
chgrp -R brewers `brew --prefix`
# Note: if you're not in the admin group, this command may require sudo.
{% endhighlight %}

And you're all set! Now any member of the group `brewers` has access to `brew install` at their whim. To add or remove users from the `brewers` group, just go back to the group in the **Users & Groups** section of **System Preferences** and change the group's membership options there.