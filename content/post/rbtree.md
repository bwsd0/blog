---
title: "Kernel rbtree"
date: 2019-06-05T16:36:07+02:00
summary: Some notes on Linux's rbtree implementation.
---

To use kernel rbtrees, insert and search cores must be implemented by the
user...

[linux/lib/rbtree.c:69](https://raw.githubusercontent.com/torvalds/linux/master/lib/rbtree.c)

```C
/*
 * Helper function for rotations:
 * - old's parent and color get assigned to new
 * - old gets assigned new as a parent and 'color' as a color.
 */
static inline void
__rb_rotate_set_parents(struct rb_node *old, struct rb_node *new,
			struct rb_root *root, int color)
{
	struct rb_node *parent = rb_parent(old);
	new->__rb_parent_color = old->__rb_parent_color;
	rb_set_parent_color(old, new, color);
	__rb_change_child(old, new, parent, root);
}
```
