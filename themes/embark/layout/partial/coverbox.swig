<a href="{{ link.href }}" class="o-grid">
  <div class="o-grid__column--1-1 o-grid__column--large-2-3">
    <img
      class="border-normal"
      src="{% if image %}{{ image }}{% else %}https://images.unsplash.com/photo-1551086144-2e1250996ba7?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1351&q=80{% endif %}"
      alt="article image"/>
  </div>

  <div class="o-grid__column--1-1 o-grid__column--large-1-3">
    {% if icon %}
      <svg class="c-icon c-icon--l">
        <use xlink:href="{{ url_for('../../assets/icons/symbols.svg') }}#icon-{{ icon }}"></use>
      </svg>
    {% endif %}
    <h3
      class="{% if titleClassName %}{{ titleClassName }}{% else %}c-body-title{% endif %} u-text-normal">{{ title }}</h3>
    {% if dateInfo %}
      <time class="c-meta u-text-normal">{{ date(dateInfo, 'Do MMMM YYYY') }}</time>{% endif %}
    <p class="c-box__subtitle u-text-normal">{{ text }}</p>
    {% if link %}
      <p class="c-box__footer">
        <span class="c-link">{{ link.text }}</span>
      </p>
    {% endif %}
  </div>
</a>

