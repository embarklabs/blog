{{
  partial('partial/header', {
    title: __(page.title),
    tagline: __(page.tagline),
    compact: true
  })
}}
<main role="main" class="o-standard-page">
  <section class="o-container o-distance">
    {{page.content}}
  </section>
</main>

