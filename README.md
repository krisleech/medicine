# Medicine

[![Gem Version](https://badge.fury.io/rb/medicine.png)](http://badge.fury.io/rb/medicine)
[![Code Climate](https://codeclimate.com/github/krisleech/medicine.png)](https://codeclimate.com/github/krisleech/medicine)
[![Build Status](https://travis-ci.org/krisleech/medicine.png?branch=master)](https://travis-ci.org/krisleech/medicine)
[![Coverage Status](https://coveralls.io/repos/krisleech/medicine/badge.png?branch=master)](https://coveralls.io/r/krisleech/medicine?branch=master)

Simple Dependency Injection for Ruby

Find yourself passing dependencies in to the initalizer? Medicine makes this
declarative.

```ruby
class CastVote
  include Medicine.di

  dependency :votes_repo, default: -> { Vote }

  def call(entry_id)
    vote_repo.create!(entry_id: entry_id)
  end
end


cast_vote = CastVote.new
cast_vote.call(3)
```

In this example Medicine adds a private method called `vote_repo` which returns `Vote`.

## Injecting a dependency

```ruby
vote_repo = double('VoteRepo')
cast_vote = CastVote.new(vote_repo: vote_repo)
```

If you want to arguments other than the dependencies in to the constructor
don't forget to invoke `super`:

```ruby
def initialize(arg1, arg2, dependencies = {})
  @arg1 = arg1
  @arg2 = arg2
  super(dependencies)
end
```

## Required dependencies

```ruby
dependency :vote_repo
```

When no default is specified and is not injected an error will be raised on
initialization.

## Default dependencies

```ruby
dependency :vote_repo, default: :vote
dependency :vote_repo, default: :Vote
dependency :vote_repo, default: 'Vote'
dependency :vote_repo, default: -> { Vote }
```

The above examples will expose a method called `vote_repo` which returns the
`Vote` class as the default dependency.
