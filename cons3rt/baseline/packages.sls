{% set packages=pillar['cons3rt-packages']['baseline_packages'] %}
{% for pkg in packages %}
cons3rt-baseline-pkg-{{pkg}}:
  pkg:
    - installed
    - name: {{pkg}}
{% endfor %}
