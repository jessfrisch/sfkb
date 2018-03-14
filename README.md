# SFKB

SalesForce Knowledge Base

A Ruby library that extends [Restforce][] to provide convenient access to
Articles and ArticlesVersions in the Salesforce Knowledge Base.

[![Build Status](https://travis-ci.org/bjjb/sfkb.svg?branch=master)](https://travis-ci.org/bjjb/sfkb)

## Requirements

- [Ruby][]
- [SalesForce][]

## Installation

    gem install sfkb

## Usage

Include it in your project, for example in your Gemfile

```ruby
gem 'sfkb'
```

or just require it.

Now you can use the module as a client, or do something fancier by
instantiating a `SFKB::Client`.

For example, here's how to print the titles of the master versions of the
first 10 documents:

```
require 'sfkb'
SFKB.new.articles.take(10).each { |a| puts a.OnlineMasterVersion.data.Title }
```

Here's how to list the titles of every translation of every draft article:
```
sf = SFKB.new
sf.articles.select(:hasTranslations?) do |a|
    sf.translations(a, 'Draft').each do |t|
        puts t.data.Title
    end
end
```

Documentation is available [here][docs].

You will need to register an app in your Salesforce instance so you can obtain
your `SALESFORCE_CLIENT_ID` and `SALESFORCE_CLIENT_SECRET` (see below).

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/bjjb/sfkb. This project is intended to be a safe,
welcoming space for collaboration, and contributors are expected to adhere to
the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## Testing

When testing, you'll want to preconfigure your environment with these
settings:

- `SALESFORCE_CLIENT_ID`
- `SALESFORCE_CLIENT_SECRET`

You might also want to set the following (which defaults to
'login.salesforce.com) to something like 'company.my.salesforce.com', or
'test.salesforce.com' if you want to use a sandbox.

- `SALESFORCE_HOST`

For authentication, you may either use the username/password/token-secret
combination:

- `SALESFORCE_USERNAME`
- `SALESFORCE_PASSWORD`
- `SALESFORCE_SECURITY_TOKEN`

or

- `SALESFORCE_OAUTH_TOKEN`
- `SALESFORCE_REFRESH_TOKEN`

the latter of which is optional, and can (and probably should) be set using
the [`authentication_callback`][1]. For more details, see [Restforce][].

## License

The gem is available as open source under the terms of the [MIT
License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Glinga project’s codebases, issue trackers, chat
rooms and mailing lists is expected to follow the [code of
conduct](https://gitlab.com/bjjb/glinga/blob/master/CODE_OF_CONDUCT.md).

[Restforce]: https://github.com/restforce/restforce
[Ruby]: https://ruby-lang.org
[Salesforce]: https://salesforce.com
[docs]: http://www.rubydoc.info/github/bjjb/sfkb
[1]: https://github.com/restforce/restforce#oauth-token-authentication
