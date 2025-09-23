---
title: Light-equator, a new unit to measure round-trip time (RTT)
---

I came up with a new unit: A *light-equator*, which measures time.
It is meant to be used to help put the round-trip time of a (HTTP) request in context.
One light-equator is the time it takes light to travel around the equator; which is about $\frac{40.075 \cdot 10^6}{3 \cdot 10^8} \approx 0.134$ seconds.

By definition the fastest time theoretically possible for a computer on the other side of the world to respond to you is 1 light-equator (unless you send some kind of beam *through* the earth).

So when you ping a server in 40ms, that means it takes 0.30 light-equators for your request to:

- Travel to the server
- Get processed
- Travel back to your device

A ping time of 8ms (which I have measured to Google's servers... over WiFi!) is 0.06 light-equators; of course only possible because Google has a datacenter very close to me.

Wow...
Computers are so fast!

## Additional remarks
WolframAlpha can calculate this for you: <https://www.wolframalpha.com/input?i=equator+length+%2F+light+speed>

I also let WolframAlpha calculate the distance from the Netherlands to New Zealand, to see how close New Zealand is to the **literal** other end of the world for me:
It's $0.46$ times the equator according to <https://www.wolframalpha.com/input?i=distance+from+netherlands+to+new+zealand> which is pretty close to the maximum of $0.5$.

The speed of light in a fiber-optic cable is actually a bit slower than $c$ (the speed of light in a vacuum),
a *fiber-light-equator* would be about 0.211 seconds [according to Wikipedia](https://en.wikipedia.org/wiki/Fiber-optic_cable#Propagation_speed_and_delay).
This makes the low ping times even more impressive.

## Nanoseconds are 30cm long
Another playful method of conceptualizing short timeframes.

Grace Hopper (who made major contributions to the field of compilers, being both the first to implement one and coining the term itself)
used to [hand out 30cm long pieces of wire](https://en.wikipedia.org/wiki/Grace_Hopper#Anecdotes) representing a nanosecond in her lectures.

This was to explain why fast computers need to be small.
Modern computers can do upwards of 5 cycles per nanosecond (5 GHz) and thus can only access information at the other end of 30cm in at most 10 cycles, causing delays.
