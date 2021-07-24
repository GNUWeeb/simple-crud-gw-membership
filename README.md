
# Simple CRUD GNU/Weeb Membership
This is a simple CRUD (Create, Read, Update, Delete) program written in Assembly
x86-64, specifically for Linux with System V AMD64 ABI calling convention. It's
still under development.

![screenshot.jpg](https://raw.githubusercontent.com/GNUWeeb/simple-crud-gw-membership/master/screenshot.jpg)


# Data Structure
In this program, we use the following struct layout to store the record.
```c
struct member {
	char	name[64];		// Name
	char	tg_username[32];	// Telegram username
	char	gender;			// m (male), f (female), h (hidden)
};
```

# Maintainer
- Ammar Faizi ([@ammarfaizi2](https://github.com/ammarfaizi2))


# Contribute
We welcome pull request on the GitHub repository
[https://github.com/GNUWeeb/simple-crud-gw-membership](https://github.com/GNUWeeb/simple-crud-gw-membership)

Reach us on our Telegram group [https://t.me/GNUWeeb](https://t.me/GNUWeeb).


# License
This software is licensed under the GNU GPL-2.0
