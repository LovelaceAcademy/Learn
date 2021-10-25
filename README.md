# Lovelace Academy: Learn  
Content for https://learn.lovelace.academy

## Development

### Install Dependencies

Builds on Ruby 2.7

```bash
gem install bundler:2.2.17
bundle install
```

### Serve Locally

```bash
bundle exec jekyll serve
```

## Usage

### Updated on

To show the last modification date, add a `last_modified_at` field on
the frontmatter with the current date.

### Notification blockquotes

If you need to create notification-styled blockquotes, add them like
this on the post file:

```markdown
<blockquote class="media notice notice-danger"><i class="icon_ribbon_alt"></i><div markdown="1">

Content parsed as **markdown**.

</div></blockquote>
```

`notice-danger` can also be `notice-success` and `notice-warning`.
Markdown parsing is possible with the `markdown="1"` attribute on the
`<div>` tag.
