<div class="o-grid {% if className %} {{ className }} {% endif %}">
  <div
    class="o-grid__column--1-1 o-grid__column--large-1-3 border-normal c-box--cover"
    style="background-image: url({% if image %}{{ image }}{% else %}/assets/images/embark-header_blank.jpg{% endif %})"
  ></div>

  <div class="o-grid__column--1-1 o-grid__column--large-2-3">
    {% if icon %}
      <svg class="c-icon c-icon--l">
        <use xlink:href="{{ url_for('../../assets/icons/symbols.svg') }}#icon-{{ icon }}"></use>
      </svg>
    {% endif %}
    <h3 class="{% if titleClassName %}{{ titleClassName }}{% else %}c-body-title{% endif %}">
      {% if linkTitle %}
        <a href="{{ link.href }}" title="{{ link.text }}"
           {% if linkClassName %}class="{{ linkClassName }}"{% endif %}>{{ title }}</a>
      {% else %}
        {{ title }}
      {% endif %}
    </h3>
    {% if dateInfo %}
      <p class="c-meta u-text-light">{{ date(dateInfo, 'Do MMMM YYYY') }}</p>
    {% endif %}
    <p class="c-box__subtitle u-text-light">{{ text }}</p>
    {% if link %}
      <p class="c-box__footer">
        <a href="{{ link.href }}" title="{{ link.text }}" class="c-link">{{ link.text }}</a>
      </p>
    {% endif %}
  </div>
</div>

