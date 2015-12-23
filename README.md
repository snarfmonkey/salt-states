# Salt State Source Control Workflow (proposed) #


## Description of problem ##
As the salt master needs closer to 100% uptime,
we want to be be able to thoroughly test salt states before merging into master.
Testing them in vagrant or docker
helps get the syntax right and avoid conflicts, but it doesn't paint the whole picture
and doesn't let us write states against different environments for
longer-term testing of viability.
I want to be able to run a state on a minion with a dev branch of code without
changing the behavior of existing states. This turns out to be less
than a trivial problem with salt.

My proposed solution fleshes out the git workflow and allows 
one to choose the branch of states they want to run on any minion
by setting its "env" grain. It also lets us to cherry pick which versions,
monitoring platforms, and settings we want on a per-environment basis.

It does, however, come with added complexity and some overhead work
to get our master and source repos in line. I think it accomplishes some
goals I have for TDD and collaboration on states, but I would like to solicit
everyone's opinions.

##Key Concepts##

What I wanted was essentially "salt 'myminion' state.highstate --use-git-branch=dev"
but that doesn't exist*. In order to understand why not, I had to 
get more familiar with the logic behind salt's state and top file compilation,
https://docs.saltstack.com/en/latest/ref/states/top.html
overcome some assumptions that I had, and, as seems quite common,
work around some perceived bugs and flaws. I will try to enumerate these things:

\* it sort of does but it's not that easy

### 1) base is not (really) prod ###

One misconception I operated under for too long was the assumption that
environment separation in the top file made 'base' the same as 
any other environment, and thus the ultimate, or "production" environment. 
That's sort of how it looks in the top file, on the same indent
level as any other defined environments.
This is technically true on the data structure level, which is to say that it's a yaml
data structure added to other yaml data structures to form
a "high state." But "base" necessarily applies to all minions,
regardless of environment, role, grains, or what-have-you.
That puts it in a category of its own in terms of version control, 
but I'll get back to that.
The main point is that it is *is assumed* that the states in 'base'
do not overlap with the rest of the states, and apply to 
*all environments*. For this reason, states and state IDs
*cannot conflict* between base and other environments,
as they will be loaded together to form the 'highstate'
data structure. In fact, if only to illustrate that they are not used, 
using this method we could (in theory) delete all other dirs 
except 'base' from the master branch, or even delete base from all other branches.
It might even be a good idea, to demonstrate it and to avoid conflicts.
Point is, base concatenates with other environments, and does not overlap.

### 2) top.sls files from branches in the same repo are merged together

As per 
https://docs.saltstack.com/en/latest/topics/tutorials/gitfs.html#branches-environments-and-top-files,
"top.sls files from different branches will be merged into one at runtime. 
Since this can lead to overly complex configurations, the recommended setup 
is to have a separate repository, containing only the top.sls file with just 
one single master branch."

Don't ask me why this is, but for a purely git-backed solution with
branch-based environments, a separate repo is necessary for the top file.
It has only a master branch, only a top.sls file, and is added to gitfs_remotes
in the master config. The top.sls file is something of an exception
to the dev/staging/master paradigm, but, if we dial it in well,
we shouldn't have to mess with it all that often. I explain below.

### 3) grains and roles, roles and grains

Grains are a really important way to describe a minion, and
'roles' is a decent standard term for describing what we want
that minion to do and be. Savvy use of roles, grains, and environments
can take the burden of describing minions off of the top.sls file
and put it more on the minion itself. This means less editing and breaking the
top.sls file with stupid whitespace errors, a smaller top.sls file,
and more flexibility when it comes to assigning arbitrary roles to a
minion for testing.

It also means that assigning grains and roles to minions is absolutely
necessary, and has to be done before a highstate. The potential for human error
aside, this can present
its own complications, as it has to be addressed during the bootstrap/install
phase of a salt minion.

To leverage these roles, we would use something like this...

## Fancy Jinja top.sls

    {# The roles grain must be formatted as a list for this black magic #}
    {% set roles = salt['grains.get']('roles', '') %}
    base:
      '*':
         - base
 
    {%- if roles is defined %}
    dev:
       'env:dev':
        - match: grain
        {%- for role in roles %}
        - {{ role }}
        {%- endfor %}

    staging:
       'env:staging':
        - match: grain
        {%- for role in roles %}
        - {{ role }}
        {%- endfor %}

    prod:
      'env:prod':
        - match: grain
        {%- for role in roles %}
        - {{ role }}
        {%- endfor %}
    {% endif %}

The top.sls file is dictating which states apply to which minions, the sum
of which is known as the "high state." Using (some variation of) the above top.sls,
the minion's high state is also the sum of it's roles, plus the states in "base."
All states that apply to a minion can be seen with ``salt '$MINION' state.show_top``

    $ sudo salt-call state.show_top
    [INFO    ] Loading fresh modules for state activity
    local:
        ----------
        base:
            - base
            - maint
        dev:
            - nodejs
            - postgres.client

...and these are the corresponding custom grains:

    $ cat /etc/salt/grains
    environment: dev
    roles:
    - nodejs
    - postgres.client
    team: it

So this minion would get the base states, and nodejs and the postgres client
from the 'dev' environment.

## Editing the Base States ##

Since 'base' applies to all minions, bungling some whitespace
in the jinja-tastic base.users state or adding base.sudo_rm-rf
could break highstate runs for everybody. On top of that, it doesn't
have a corresponding dev branch for testing. However, it is possible 
to test a base state by adding it to a dev branch and then
giving a minion the role of base.new-state-to-test-in-dev to apply
the base state to it thoroughly before merging it into 'master' (a.k.a 'base').

## Pillar ##

I can see the same setup working in the pillar top.sls file,
the file that dictates which supplementary and/or secret
data that a minion has access to. This introduces it's own
organizational paradigm if we hope to reduce the number of 
grains, and is arguably a more monumental task of re-organizing than
the states. This leads me to consider some...

## Potential problems with my genius idea ##

### Issues doing this with pillar ###

The pillar seems like one example where this could be annoying
and the number of 'roles' could proliferate. It would help to duplicate states
and pillar names so that it applied to both (and values that vary between environments
are done via the env grain), but it wouldn't work in all cases and might get messy.
We don't have a UI like github for the pillar repo, and github does make visualizing 
code changes and the source flow easier, so that's another bummer. It would also mean
a secondary top.sls pillar repo, but at this point that's one more?

All that said, it's perfectly possible to break salt by futzing up the pillar 
file, too. It wouldn't hurt to make fewer edits to pillar's top.sls.
