---
title: Lifelong recording is actually feasible
---

A [lifelog](https://en.wikipedia.org/wiki/Lifelog) is "a personal record of one's daily life".
It can be seen as a type of [sousveillance](https://en.wikipedia.org/wiki/Sousveillance), if everyone did this then everybody is surveilling everybody.
The [quantified self](https://en.wikipedia.org/wiki/Quantified_self) movement is also related.

### Video
Could I archive a 24/7 stream of what I see every day?
Possibly, but you'd either get incredibly crappy resolution or incredibly large storage needs.
A 2 hour movie (in kinda crappy but perfectly watchable Full-HD) tends to be about 2 GB.
That would give $12 * 2 = 24$ GB per day, subtract 8 hours because we are sleeping and we still get 16 GB / day or 5844 GB / year.
So over a lifetime of 80 years that would be about 467 TB.

This is a *large* amount of data, darn expensive to store (for now?),
not actually that useful (how are you going to find anything?), but surprisingly enough technically feasible.

Suppose we set aside 20TB^[This fits on **one** admittedly very large harddisk!] of space to record what we see and again subtract 8 hours per day for sleeping.
Assuming an average photo size of 2MB this means we can take a photo every $80 * 364.24 * 16 * 3600 / \frac{20 * 10^{12}}{2 * 10^6} \approx 168$ seconds or every 3 minutes.
That should still give a decent idea of what you've been up to at a particular day.

### Audio
What about sound? Can I store everything I hear?
I'm gonna try a kinda crappy but perfectly functional bitrate of 128 kbps.
This means 16 KB/s = 1.38 GB per day. If we account for sleeping again it's 0.922 GB per day.
A lifetime is sounding actually kind of reasonable at 26.9 TB.

### Text
How about we try to store everything you read and type?
This one isn't really recording all the time so keep in mind that I'm calculating an upper bound and it will be *much* lower in reality.
We're also assuming everything will be stored in raw ASCII (1 byte per character) while in practice text compresses very well.

Humans (of which I am one) can read at roughly 200 words per minute.
^[Apparently the anatomy of the eye gives a hard limit of 900 words per minute.]
Reading 200 words per minute, 16 hours per day (which is NOT realistic) and an average of 5 characters per word gives 5.6 GB over an 80 year lifetime.
This is perfectly reasonable to store (and will be *much* smaller in reality).

I'm taking 120 wpm as a reasonable upper boundary of what you can type, this is over 3 times the speed of "hunt and peck" typing. 
Repeating the calculation I arrive at an upper bound of 3.4 GB over 80 years.

#### Recording terminals
Hey! Terminals are all text aren't they?^[An exception to this is the various nonstandard protocols for images that have been hacked on so far.]
Yes. Is there some way to just record that?
[asciinema](https://docs.asciinema.org/how-it-works/) does it!

<!-- Slightly more info on file size at <https://github.com/orgs/asciinema/discussions/52> -->
<!-- Additional discussion on possibilities at <https://github.com/orgs/asciinema/discussions/86> -->

### Recording your internet traffic
[Someone at gwern.net](https://gwern.net/archiving) archived all the URLs they browsed in a year, then removed files over 4MB
^[These are most likely bulky audio/video files. Normal images so far usually come in below 4MB but their size is going up and high-res pictures already often exceed that.]
and came in at 30-50 GB a year.

After manual pruning and some compression the author came in at 55GB after 6 years.

All this is actually surprisingly doable.
You may not have all of the videos you watched and podcasts you listened to,
but all of the text you read is there.

## Problems
### Ethics and laws
All kinds of ethical and legal issues here of course.
^[Yes, things that are legal are not automatically ethical and I hate that we seem to be losing that distinction. Ethical things can also be illegal, although we generally try to make these situations rare.]
Some of them can be solved by only very selectively sharing your recordings with anybody else, but a lot will remain.

### Security
Help! This is a bad idea.
You'd have probably even larger concerns than with [Microsoft Recall](https://en.wikipedia.org/wiki/Microsoft_Recall) given that this recording is even more invasive.
It is thus **very important** that you yourself are in control,
not some data-hungry, privacy-invading, multinational megacorporation.

I highly recommend airgapping your system, this eliminates much of the attack vectors but does make e.g. backups more difficult.
These backups should also be done to another airgapped system.
Or just, you know, don't try to record everything.

### Should you actually attempt this?
Probably not, but as a thought experiment I do find it interesting.
It's worth noting that recording different things provides different risks.

A keylogger is mostly only a risk to yourself, although keylogged passwords could pose a risk to your work/volunteer organisations as well.

Constant recording of audio/video in private settings is highly illegal in many countries.
Public places tend to have fewer restrictions, especially if you make very clear that you are recording.

An automatic face-blur could help, although it will inevitably fail in edge cases.
It would also mess up your precious images with your friends and family.
