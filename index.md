---
layout: lesson
root: .  # Is the only page that doesn't follow the pattern /:path/index.html
permalink: index.html  # Is the only page that doesn't follow the pattern /:path/index.html
---
This is an introduction to High-Performance Computing (HPC) and Research Computing in general for users of our clusters.
You will learn the basic command line interface, editors, job submission, and a few other topics that allow you to make efficient use of a High Performance Computing cluster.

This lesson pretends to go straight to the point. You will learn the most useful tools, commands, and techniques to start using the cluster for your research. As such, no completeness should be assumed. For each episode, there is a lot more to explore on the interest of more advanced users. Some references are left at the end of each section.


<!-- this is an html comment -->

{% comment %} This is a comment in Liquid {% endcomment %}

> ## Prerequisites
>
> This lesson assumes no previous knowledge of Linux and the command line interface (CLI). If you are only familiar with GUI applications on any OS (Windows, MacOS, or Linux) expect a bit of a rough start but please do not lose your motivation. Learning Linux and command lines is like exploring a new language, expect mistakes and frustrations, but also rewards as you move forward and start grasping the tools that will make your interaction with the cluster more efficient and your research more dynamic.
>  
{: .prereq}

**Testing LaTeX support in the (Lesson/Workshop) The Cauchy-Schwarz Inequality**

$$\left( \sum_{k=1}^n a_k b_k \right)^2 \leq \left( \sum_{k=1}^n a_k^2 \right) \left( \sum_{k=1}^n b_k^2 \right)$$

<p id="This_Is_What_I_Want"> $$ (a-b)^2 $$</p>
<p id="First_Input"> <input id="Value_A"></p>
<p id="Second_Input"> <input id="Value_B"></p>
<p id="Output"></p>
<p id="Activate"><button onclick="RUN()">Test This out</button></p>
<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.5/MathJax.js?config=TeX-AMS_HTML,http://myserver.com/MathJax/config/local/local.js">
        function RUN() {
            var a = document.getElementById("Value_A").value
            var b = document.getElementById("Value_B").value
            document.getElementById("Output").innerHTML = "$$ (" + a + "-" + b + ")^2 $$";
            MathJax.Hub.Queue(["Typeset", MathJax.Hub]);
        }
</script>

{% include links.md %}
