### What is this
This is a fork of the [GNOME/gjs-documentation](https://github.com/GNOME/gjs-documentation) with pre-generated and possibly updated documentation [directly in the html folder](./html) or [via gh-pages](http://webreflection.github.io/gjs-documentation/)

Since it took 5 days to me to figure out *how to build GJS documentation*, I thought it would have been easier to have a pre-published repository instead of going through the whole `jhbuild` process ... however ...


### How to make `jhbuild` work in ArchLinux
In my case [this post](https://mohan43u.wordpress.com/2015/01/17/setup-gnome-development-environment-in-archlinux/) followed step by step was the only way to have  `jhbuild` working as expected.

Moreover, there is an [AUR jhbuild package](https://aur.archlinux.org/packages/jhbuild/) that maybe works for you, it didn't in my case.

The most important bit was to specify the right `prefix`. As example, following the first post this is the way to actually build this documentation (you need basically the entirity of GNOME modules already built though)
```sh
BASE=~/Devel/gnome/runtime/usr && $BASE/bin/jhbuild run make prefix=$BASE
```