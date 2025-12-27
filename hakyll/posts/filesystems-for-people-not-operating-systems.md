---
title: Filesystems for people, not operating systems
---

Or, picking a fight with hierarchical filesystems (which is all of them).
<!-- See [[id:4fa51437-2672-43fd-9a38-88acff79daed][Human File System]] --> 

Recently I asked myself whether I knew any filesystems specifically meant for users.
I define a filesystem meant for users as one that would be meant to contain your home directory and aid you in managing your files.
This is in opposition to a filesystem meant for operating systems, meaning one meant to contain your root directory with all of your system files and yes, as an afterthought often your home directory as well.

I realized that I didn't know any such filesystems meant for users, which I call *Human File Systems*.
During a discussion, my father came up with the *Files* app on iOS as a possible exception.

But the Files app was only reluctantly added by Apple, after people complained for *over a decade* that they couldn't use files on iOS.
It was not exactly meant to be a revolution, more as a compromise to stop one.

## ZFS
I consider ZFS to be a large step forwards for users.
It's less focused on performance and operating systems and more on system administrators.
In my view it does however still not cater to actual *users*.

I consider its most important feature to be sharing space between "partitions"^[ZFS calls them *datasets*].
A user with two `ext4` partitions on a disk must decide up front how much space each one gets.
Changing this allocation is possible but painful and involves manual action and scary commands.
ZFS handles this completely automatically, allocating space to whichever data set needs it in a *pool* without any user interaction.
^[Optionally limits can be set on a dataset to prevent it from taking up all of the available capacity.]

Additional nice features for users include:

- Snapshots
- Simplifying backups
- Redundancy with RAID
- Compression, this works well for large amounts of plaintext

## Semantic and tagging filesystems
Or, why hierarchical filesystems are actually a good idea.

Hierarchical filesystems give files a *place* in the *space* of the filesystem.
Humans are very good at navigating physical spaces, they also turn it to be pretty good at navigating hierarchical filesystems.

Semantic and tagging filesystems lose this connection to a place.
They ask the user to *search* for stuff using *queries*^[I consider a combination of tags to be a query.].
Although tagging and search systems have shown great promise in collaborative systems of large groups of people (search engines, social media) they have consistently sucked for individual usecases.

TODO: Mention [folksonomies](https://en.wikipedia.org/wiki/Folksonomy).

People consistently [prefer navigation over search](https://thesephist.com/posts/search-vs-nav/).

## Graph filesystems
I consider the most promising direction to be [graph filesystems](https://fsgeek.ca/2019/05/09/graph-file-systems/).
It's a straight-up generalisation of hierarchical filesystems and thus remains backwards-compatible with existing cultural practices around files.

Graph filesystems allow forming [heterarchies](https://en.wikipedia.org/wiki/Heterarchy) which can be used to create multiple views into the same information.

## URL filesystems
URLs mimic file paths very closely.
There's even a way to encode file paths in URLs via the `file` URI.

Nevertheless there is a key difference between URLs and file paths:
A file path always encodes a directory **or** a file, a URL *can* (although uncommon) be both.
A trailing `/` in a URL is *semantically meaningful* and can alter the response you get.
For URLs, paths can both contain subpaths **and** data.

This can come in handy.
The Rust programming language, for example, uses a `mod.rs` file to store the data of the module named after its parent directory.
In the URL system this is unnecessary.

See <https://fkohlgrueber.github.io/blog/tree-structure-of-file-systems/> for more detail.

## Further reading
- <https://en.wikipedia.org/wiki/Semantic_triple> and <https://en.wikipedia.org/wiki/Semantic_Web> making use of it
- <https://www.nayuki.io/page/designing-better-file-organization-around-tags-not-hierarchies>
- <https://newsletter.squishy.computer/p/all-you-need-is-links>
- <https://newsletter.squishy.computer/p/knowledge-structures>
- The Apple Newton apparently used a novel method of storing data: <https://www.canicula.com/newton/prog/soups.htm>
