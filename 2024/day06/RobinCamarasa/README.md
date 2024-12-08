<div>

<div>

# [Advent of Code](/) {#advent-of-code .title-global}

-   [\[About\]](/2024/about)
-   [\[Events\]](/2024/events)
-   [\[Shop\]](https://cottonbureau.com/people/advent-of-code){target="_blank"}
-   [\[Log In\]](/2024/auth/login)

</div>

<div>

#    [0x0000\|]{.title-event-wrap}[2024](/2024)[]{.title-event-wrap} {#x00002024 .title-event}

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
[Zero To
Mastery](/2024/sponsors/redirect?url=https%3A%2F%2Flinks%2Ezerotomastery%2Eio%2Faoc2024){target="_blank"
onclick="if(ga)ga('send','event','sponsor','sidebar',this.href);"
rel="noopener"} - Ready to upgrade your earning power? If you like AoC,
you\'ll like our courses built by programmers (not influencers), for
programmers. ZTM helps you get a better job, and earn more with one
trick: quality, not gimmicks.
:::
:::
:::

::: {role="main"}
## \-\-- Day 6: Guard Gallivant \-\--

The Historians use their fancy [device](4) again, this time to whisk you
all away to the North Pole prototype suit manufacturing lab\... in the
year [1518](/2018/day/5)! It turns out that having direct access to
history is very convenient for a group of historians.

You still have to be careful of time paradoxes, and so it will be
important to avoid anyone from 1518 while The Historians search for the
Chief. Unfortunately, a single *guard* is patrolling this part of the
lab.

Maybe you can work out where the guard will go ahead of time so that The
Historians can search safely?

You start by making a map (your puzzle input) of the situation. For
example:

    ....#.....
    .........#
    ..........
    ..#.......
    .......#..
    ..........
    .#..^.....
    ........#.
    #.........
    ......#...

The map shows the current position of the guard with `^` (to indicate
the guard is currently facing *up* from the perspective of the map). Any
*obstructions* - crates, desks, alchemical reactors, etc. - are shown as
`#`.

Lab guards in 1518 follow a very strict patrol protocol which involves
repeatedly following these steps:

-   If there is something directly in front of you, turn right 90
    degrees.
-   Otherwise, take a step forward.

Following the above protocol, the guard moves up several times until she
reaches an obstacle (in this case, a pile of failed suit prototypes):

    ....#.....
    ....^....#
    ..........
    ..#.......
    .......#..
    ..........
    .#........
    ........#.
    #.........
    ......#...

Because there is now an obstacle in front of the guard, she turns right
before continuing straight in her new facing direction:

    ....#.....
    ........>#
    ..........
    ..#.......
    .......#..
    ..........
    .#........
    ........#.
    #.........
    ......#...

Reaching another obstacle (a spool of several *very* long polymers), she
turns right again and continues downward:

    ....#.....
    .........#
    ..........
    ..#.......
    .......#..
    ..........
    .#......v.
    ........#.
    #.........
    ......#...

This process continues for a while, but the guard eventually leaves the
mapped area (after walking past a tank of universal solvent):

    ....#.....
    .........#
    ..........
    ..#.......
    .......#..
    ..........
    .#........
    ........#.
    #.........
    ......#v..

By predicting the guard\'s route, you can determine which specific
positions in the lab will be in the patrol path. *Including the guard\'s
starting position*, the positions visited by the guard before leaving
the area are marked with an `X`:

    ....#.....
    ....XXXXX#
    ....X...X.
    ..#.X...X.
    ..XXXXX#X.
    ..X.X.X.X.
    .#XXXXXXX.
    .XXXXXXX#.
    #XXXXXXX..
    ......#X..

In this example, the guard will visit *`41`* distinct positions on your
map.

Predict the path of the guard. *How many distinct positions will the
guard visit before leaving the mapped area?*

To play, please identify yourself via one of these services:

[\[GitHub\]](/auth/github) [\[Google\]](/auth/google)
[\[Twitter\]](/auth/twitter) [\[Reddit\]](/auth/reddit) [- [\[How Does
Auth Work?\]](/about#faq_auth)]{.quiet}
:::
