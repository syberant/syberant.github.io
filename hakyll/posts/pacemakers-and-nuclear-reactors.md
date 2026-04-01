---
title: "Error handling: pacemakers and nuclear reactors"
---

NOTE: None of what I'm going to tell you about are original thoughts, they have been floating around online in various forms.
I make no claim to originality but also can't point to some concrete source, this is my own retelling.

Doing error handling properly is difficult.
Different people/companies/languages/communities/etc. do it in different ways and I think it's fair to say that we haven't "solved" error handling yet.

I'll just tell you straight that I don't "know" error handling and won't pretend to have the answer to your questions.
My own favorite programming language, Rust, has multiple popular methods of doing error handling with a lot of (seemingly good natured, that's nice) debate on how you "should" do it.
^[TODO: links to some blogposts]

But there is one thing that seems to be universally important.
You should ask yourself: Where does my usecase fall on the spectrum between pacemakers and nuclear reactors?

### Pacemakers
Pacemakers are devices that are implanted next to your heart to make sure it beats reliably.
Skipping over a lot of medical detail which I don't know because I'm not a doctor:
A pacemaker malfunctioning or shutting off entirely carries a substantially increased risk of death.

Pacemakers *should not kill people*.
I don't care what you do, but that heart must *keep beating*.

### Nuclear reactors
At the other end of the spectrum we have nuclear reactors.
I don't care whether or not you think you might be able to recover from that error,
if there is anything even slightly unexpected you **shut that thing down immediately**.
Everything in a nuclear reactor is engineered to ensure that outcome.

Moreover they don't trust the code one bit so ensure there are plenty of analog, mechanical or materials sciency things that will ensure a nuclear power plant **stops** instead of coating half a continent in nuclear waste.

### Conclusion
Should your program continue as best it can or error out at first opportunity?
This is for you to decide.
