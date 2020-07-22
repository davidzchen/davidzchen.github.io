# dzc personal website

[davidzchen.com](http://davidzchen.com)

## Bringing up a local instance

Configure Bundler to install gems in the local `./vendor/bundle` directory:

```sh
bundle config set --local path 'vendor/bundle'
```

Install gems:

```sh
bundle install
```

Bring up a local instance:

```sh
bundle exec jekyll serve
```
