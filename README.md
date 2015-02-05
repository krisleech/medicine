# Isopod

Simple Dependency Injection for Ruby

Find yourself passing dependencies in to the initalizer? Isopod makes this
declarative.

```ruby
class CastVote
  include Isopod.di

  dependency :votes_repo, default: -> { Vote }

  def call(entry_id)
    vote_repo.create!(entry_id: entry_id)
  end
end


cast_vote = CastVote.new
cast_vote.call(3)
```

In this example Isopod adds a private method called `vote_repo` which returns `Vote`.

## Injecting a dependency

```ruby
vote_repo = double('VoteRepo')
cast_vote = CastVote.new(vote_repo: vote_repo)

# or

cast_vote = CastVote.new(arg1, arg2, vote_repo: vote_repo)
```

## Required dependencies

```ruby
dependency :vote_repo
```

When no default is specified and is not injected an error will be raised on
initialization.

## Default dependencies

```ruby
dependency :vote_repo, default: :Vote
dependency :vote_repo, default: 'Vote'
dependency :vote_repo, default: -> { Vote }
```

The above examples will expose a method called `vote_repo` which returns the 
`Vote` class as the default dependency.

You could also pass an object which responds to call and accepts one argument,
the name of the dependency

```ruby
dependency :vote_repo, default: Repo
```

```ruby
class Repo
  def self.call(name)
    Kernel.constant_get(name.gsub('_repo', ''))
  end
end
```

In this example the `vote_repo` method will return the `Vote` class.
