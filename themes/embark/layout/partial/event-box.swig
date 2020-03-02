<a class="{% if className %} {{ className }} {% endif %}" href="{{ link.href }}">
  <div
    class="border-normal c-box--cover"
    style="background-image: url({% if image %}{{ image }}{% else %}/assets/images/embark-header_blank.jpg{% endif %})"
  ></div>

  {% if eventDate %}<span class="c-tag c-tag--light c-box__offset">{{eventDate}}</span>{% endif %}
  <h3 class="c-body-title u-text-normal o-distance-m">
    {% if linkTitle %}
     {{name}}
    {% else %}
      {{name}}
    {% endif %}
  </h3>
  {% if dateInfo || location %}
    <p class="c-meta u-text-normal">
    {% if location %}{{location}}{% endif %}
    {% if dateInfo %}{{date(dateInfo, 'Do MMMM YYYY')}}{% endif %}
    </p>
  {% endif %}
  <p class="c-box__subtitle u-text-normal">{{description}}</p>
  {% if link %}
  <p class="c-box__footer">
    <p>{{link.text}}</p>
  </p>
  {% endif %}
</a>

