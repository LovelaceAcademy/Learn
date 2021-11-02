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

### Tabbed content

This project uses the `jekyll-simple-tab` gem. Check the [Jekyll Simple Tabs documentation](https://github.com/Applifort/jekyll-simple-tab/blob/master/README.md#usage) for a usage example.

### Tooltips

There are two types of tooltips available. Basic tooltips are good for displaying some small amount of text and can be included in markdown

```liquid
{% include tooltips/basic.html tooltip="Your text here" content="Lorem Ipsum" %}
```
A basic tooltip is blue by default but can be made orange with `orange=true`

Advanced tooltips are for longer, formatted content and consist of two parts. First an includes with the text you would like users to hover on

```liquid
{% include tooltips/advanced.html content="James Bond David" label="tooltipOne" %}

```

Then at the end of the post, you can write the content of this tooltip, making sure to use the same label

```markdown
{% include tooltips/content.html label="tooltipOne" %}

Nisl vel pretium lectus quam id leo in vitae. Id eu nisl nunc mi ipsum faucibus vitae aliquet nec. Viverra mauris in aliquam sem fringilla ut morbi tincidunt. Fermentum posuere urna nec tincidunt praesent semper feugiat nibh sed.
    
## Related Reading: Child Theming for Layers

{% include tooltips/endcontent.html %}
```

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
