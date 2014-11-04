# Isopod

Simple Dependency Injection for Ruby

```ruby
class CastVote
  include Isopod.di
  
  depends_on :votes_repo, :vote
  
  def call(entry_id)
    vote_repo.create(entry_id: entry_id)
  end
end


cast_vote = CastVote.new
cast_vote.call(3)
```

## Injecting a dependency

### using a setter

```ruby
cast_vote = CastVote.new
cast_vote.depends_on(:vote_repo, double('Vote'))
```

### using an initializer

```ruby
cast_vote = CastVote.new(vote_repo: double('Vote'))

cast_vote = CastVote.new(depends_on: { vote_repo: double('Vote') })

cast_vote = CastVote.new(arg1, arg2, vote_repo: double('Vote'))
```

## depends_on

### Required dependencies

```ruby
depends_on :vote_repo
```

If this dependency is not injected an error is raied if the `vote_repo` method is called.

### Optional dependencies

```ruby
depends_on :vote_repo, :vote
depends_on :vote_repo, -> { Vote }
```

Both the above examples  will expose a method called `vote_repo` which returns the `Vote` class as the default dependency.

### Dynamic dependencies

You can pass a lambda or any object which responds to `call` to dynamically resolve a dependency. If the `call` method accepts an argument it will receive the dependency name.

```ruby
depends_on :vote_repo, Repo
```

```ruby
class Repo
  def self.call(name)
    name.gsub('_repo', '').constantize
  end
end
```

In this example the `vote_repo` method will return the `Vote` class.
