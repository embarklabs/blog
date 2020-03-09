{{ partial('partial/header', {
  title: __(page.title),
  tagline: __(page.tagline),
  compact: true,
  showTags: true
}) }}

{% set len = site.posts.length %}
{% set sortedPosts = site.posts.sort('date', 'desc') %}
{% set posts = sortedPosts.toArray() %}

<main role="main">
  <section class="o-container o-distance">
    {{ partial('partial/coverbox', {
      title: posts[0].title,
      titleClassName: 'c-title-level-2',
      text: posts[0].summary,
      image: posts[0].image,
      dateInfo: posts[0].date,
      link: {
        text: 'Read more',
        href: url_for(posts[0].path)
      }
    }) }}
  </section>
  <section class="o-distance-l o-container">
    <div class="o-grid">
      {% for i in [1, 2] %}
        {{ partial('partial/event-box', {
          className: 'o-grid__column--1-1 o-grid__column--large-1-2',
          name: posts[i].title,
          image: posts[i].image,
          linkTitle: true,
          dateInfo: date(posts[i].date),
          description: posts[i].summary,
          link: {
            text: 'Read more',
            href: url_for(posts[i].path)
          }
        }) }}
      {% endfor %}
    </div>
  </section>
  <section class="o-distance-l o-container">
    <div class="o-grid">
      {% for i in [3, 4, 5, 6, 7, 8] %}
        {{ partial('partial/event-box', {
          className: 'o-grid__column--1-1 o-grid__column--large-1-3',
          name: posts[i].title,
          image: posts[i].image,
          linkTitle: true,
          dateInfo: date(posts[i].date),
          description: posts[i].summary,
          link: {
            text: 'Read more',
            href: url_for(posts[i].path)
          }
        }) }}
      {% endfor %}
    </div>
  </section>

  <div class="o-container o-distance-l o-center">
    <a href="/archives" class="c-button" title="{{ __('blog.view_all_link') }}">{{ __('blog.view_all_link') }}</a>
  </div>
</main>

