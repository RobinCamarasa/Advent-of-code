<div>

<div>

# [Advent of Code](/) {#advent-of-code .title-global}

-   [\[About\]](/2024/about)
-   [\[Events\]](/2024/events)
-   [\[Shop\]](https://cottonbureau.com/people/advent-of-code){target="_blank"}
-   [\[Log In\]](/2024/auth/login)

</div>

<div>

#    [sub y{]{.title-event-wrap}[2024](/2024)[}]{.title-event-wrap} {#sub-y2024 .title-event}

-   [\[Calendar\]](/2024)
-   [\[AoC++\]](/2024/support)
-   [\[Sponsors\]](/2024/sponsors)
-   [\[Leaderboard\]](/2024/leaderboard)
-   [\[Stats\]](/2024/stats)

</div>

</div>

::: {#sidebar}
::: {#sponsor}
::: quiet
Our [sponsors](/2024/sponsors) help make Advent of Code possible:
:::

::: sponsor
[JPMorgan
Chase](/2024/sponsors/redirect?url=https%3A%2F%2Fwww%2Ejpmorgan%2Ecom%2F){target="_blank"
onclick="if(ga)ga('send','event','sponsor','sidebar',this.href);"
rel="noopener"} - With 60,000+ technologists globally and an annual tech
spend of \$17 billion, JPMorgan Chase is dedicated to improving the
design, analytics, coding and testing that goes into creating high
quality software products.
:::
:::
:::

::: {role="main"}
## \-\-- Day 8: Resonant Collinearity \-\--

You find yourselves on the [roof](/2016/day/25) of a top-secret Easter
Bunny installation.

While The Historians do their thing, you take a look at the familiar
*huge antenna*. Much to your surprise, it seems to have been
reconfigured to emit a signal that makes people 0.1% more likely to buy
Easter Bunny brand [Imitation
Mediocre]{title="They could have imitated delicious chocolate, but the mediocre chocolate is WAY easier to imitate."}
Chocolate as a Christmas gift! Unthinkable!

Scanning across the city, you find that there are actually many such
antennas. Each antenna is tuned to a specific *frequency* indicated by a
single lowercase letter, uppercase letter, or digit. You create a map
(your puzzle input) of these antennas. For example:

    ............
    ........0...
    .....0......
    .......0....
    ....0.......
    ......A.....
    ............
    ............
    ........A...
    .........A..
    ............
    ............

The signal only applies its nefarious effect at specific *antinodes*
based on the resonant frequencies of the antennas. In particular, an
antinode occurs at any point that is perfectly in line with two antennas
of the same frequency - but only when one of the antennas is twice as
far away as the other. This means that for any pair of antennas with the
same frequency, there are two antinodes, one on either side of them.

So, for these two antennas with frequency `a`, they create the two
antinodes marked with `#`:

    ..........
    ...#......
    ..........
    ....a.....
    ..........
    .....a....
    ..........
    ......#...
    ..........
    ..........

Adding a third antenna with the same frequency creates several more
antinodes. It would ideally add four antinodes, but two are off the
right side of the map, so instead it adds only two:

    ..........
    ...#......
    #.........
    ....a.....
    ........a.
    .....a....
    ..#.......
    ......#...
    ..........
    ..........

Antennas with different frequencies don\'t create antinodes; `A` and `a`
count as different frequencies. However, antinodes *can* occur at
locations that contain antennas. In this diagram, the lone antenna with
frequency capital `A` creates no antinodes but has a
lowercase-`a`-frequency antinode at its location:

    ..........
    ...#......
    #.........
    ....a.....
    ........a.
    .....a....
    ..#.......
    ......A...
    ..........
    ..........

The first example has antennas with two different frequencies, so the
antinodes they create look like this, plus an antinode overlapping the
topmost `A`-frequency antenna:

    ......#....#
    ...#....0...
    ....#0....#.
    ..#....0....
    ....0....#..
    .#....A.....
    ...#........
    #......#....
    ........A...
    .........A..
    ..........#.
    ..........#.

Because the topmost `A`-frequency antenna overlaps with a `0`-frequency
antinode, there are *`14`* total unique locations that contain an
antinode within the bounds of the map.

Calculate the impact of the signal. *How many unique locations within
the bounds of the map contain an antinode?*

To play, please identify yourself via one of these services:

[\[GitHub\]](/auth/github) [\[Google\]](/auth/google)
[\[Twitter\]](/auth/twitter) [\[Reddit\]](/auth/reddit) [- [\[How Does
Auth Work?\]](/about#faq_auth)]{.quiet}
:::
