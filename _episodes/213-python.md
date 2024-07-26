---
title: "Python Scripting for HPC"
teaching: 90
exercises: 30
questions:
- "How to use numpy to manipulate multidimensional arrays in Python?"
- "How I split and select portions of a numpy array?"
objectives:
- "Learn to create, manipulate, and slice numpy arrays"
keypoints:
- "numpy is the standard de-facto for numerical calculations at large scale in Python"
---

![Python Programming for Scientists in a hurry]({{ page.root }}/figTitle_Python.png)

<div style="clear: both; display: table;">
  <div style="border: none; float: left; width: 60%; padding: 5px">
  <h1 id="subtitle">Chapter 7. Pandas</h1>
  <h2 id="subtitle">Guillermo Avendaño Franco<br>Aldo Humberto Romero</h2>
  <br>
  <img src="{{ page.root }}/fig1-line logotype124-295.png" alt="Scientific Computing with Python" style="width:50%" align="left">
  </div>
  <div style="border: none; float: left; width: 30%; padding: 5px">
  <img src="{{ page.root }}/figSCPython.png" alt="Scientific Computing with Python" style="width:100%">
  </div>
</div>

## List of Notebooks

Python is a great general-purpose programming language on its own. 
Python is a general purpose programming language. It is interpreted and dynamically typed and is very suited for interactive work and quick prototyping while being powerful enough to write large applications in.
The lesson is particularly oriented to Scientific Computing. 
Other episodes in the series include:

  * Language Syntax
  * Standard Library
  * Scientific Packages
  * NumPy
  * Matplotlib
  * SciPy 
  * **Pandas \[This notebook\]**
  * Cython
  * Parallel Computing

After completing all the series in this lesson you will realize that python has become a powerful environment for scientific computing at several levels, from interactive computing to scripting to big project developments.

## Setup


```python
%load_ext watermark
```


```python
%watermark
```

    Last updated: 2024-07-26T13:27:25.045249-04:00
    
    Python implementation: CPython
    Python version       : 3.11.7
    IPython version      : 8.14.0
    
    Compiler    : Clang 12.0.0 (clang-1200.0.32.29)
    OS          : Darwin
    Release     : 20.6.0
    Machine     : x86_64
    Processor   : i386
    CPU cores   : 8
    Architecture: 64bit
    



```python
import os
import time
start = time.time()
chapter_number = 7
import matplotlib
%matplotlib inline
%load_ext autoreload
%autoreload 2
```


```python
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
```


```python
%watermark -iv
```

    matplotlib: 3.8.2
    pandas    : 1.5.3
    numpy     : 1.26.2
    


# Pandas (Data Analysis)

In this tutorial, we will cover:

* Create DataFrames directly and from several file formats
* Extract specific rows and columns

The purpose of this notebook is to show the basic elements that make Pandas a very effective tool for data analysis.
In particular the focus will be on dealing with scientific data rather than a more broad "another dataset" approach 
from most tutorials of this kind.

**pandas** is an open source, BSD-licensed library providing high-performance, easy-to-use data structures and data analysis tools for the Python programming language. It was created by Wes McKinney. 

**pandas** is a NumFOCUS-sponsored project. It is a well-established API and it is the foundation of several other packages used in data analysis, data mining, and machine learning applications.

Pandas is one of the most often asked questions on Stack Overflow, in part due to its rising popularity but also due to the versatility in manipulating data.

<img src="{{ page.root }}/figatlas_Sk4U7xecQ@2x.png" width=500px />

Pandas can be used also in scripts and bigger applications. However, it is easier to learn it from an interactive computing perspective. So we will use this notebook for that purpose. For anything that is not covered here, there are two good resources you need to consider. One is the pandas' webpage and the other one is [stackoverflow.com](http:stackoverflow.com).

The command above exposes all the functionality of pandas under the `pd` namespace. This namespace is optional and its name arbitrary but with time it has been converted into *the-facto* usage.

Pandas deals with basically two kinds of data: Series and Dataframe. Series is just a collection of values like


```python
fibo=pd.Series([1,1,2,3,5,8,13])
```


```python
fibo
```




    0     1
    1     1
    2     2
    3     3
    4     5
    5     8
    6    13
    dtype: int64




```python
#Let us see other example
a={'France':'Paris','Colombia':'Bogota','Argentina':'Buenos Aires','Chile':'Santiago'}
b=pd.Series(a)
print(b)
```

    France              Paris
    Colombia           Bogota
    Argentina    Buenos Aires
    Chile            Santiago
    dtype: object



```python
print(b.index)
```

    Index(['France', 'Colombia', 'Argentina', 'Chile'], dtype='object')



```python
#We can also create the list by passing the index as a list
c=pd.Series(['France','Colombia','Argentina','Chile'],index=['Paris','Bogota','Buenos Aires','Santiago'])
print(c)
```

    Paris              France
    Bogota           Colombia
    Buenos Aires    Argentina
    Santiago            Chile
    dtype: object



```python
# to look for the 3rd Capital in this list. Remember that here the country name is the indexing
print(b.iloc[2])
# to look for the capital of Argentina
print(b.loc['Argentina'])
# we can use the following but we have to be careful
print(b[2])
#why? because
a={1:'France',2:'Colombia',3:'Argentina',4:'Chile'}
p=pd.Series(a)
#here we will print what happens with index 2, no by the "position 2". For that reason
# it is always better to use iloc when querying a position
print(p[2])

```

    Buenos Aires
    Buenos Aires
    Buenos Aires
    Colombia



```python
data1=['a','b','c','d',None]
pd.Series(data1)
```




    0       a
    1       b
    2       c
    3       d
    4    None
    dtype: object




```python
#Here we stress that NaN is the same as None but it is number
data2=[1,2,2,3,None]
pd.Series(data2)
```




    0    1.0
    1    2.0
    2    2.0
    3    3.0
    4    NaN
    dtype: float64




```python
#To see why this is important, let's see what Numpy says about None
import numpy as np
print(np.nan == None)
# more interesting is if we compare np.nan with itself
print(np.nan == np.nan)
#THerefore we need a special function to check the existence of a Nan such as
print(np.isnan(np.nan))
```

    False
    False
    True



```python
# we can also mix types
a=pd.Series([1,2,3])
print(a)
#now we add a new entry
a.loc['New capital']='None'
print(a)
```

    0    1
    1    2
    2    3
    dtype: int64
    0                 1
    1                 2
    2                 3
    New capital    None
    dtype: object


Dataframes are tables, consider for example this table with the Boiling Points for common Liquids and Gases at Atmospheric pressure. Data from <https://www.engineeringtoolbox.com/boiling-points-fluids-gases-d_155.html>

| Product | Boiling Point (C) | Boiling Point (F) |
|:--------|:--------------|:----------------------|
|Acetylene 	|-84          | -119|
|Ammonia 	|-35.5  	  | -28.1|
|Ethanol 	| 78.4 	      | 173|
|Isopropyl Alcohol |	80.3  |	177|
|Mercury 	| 356.9 	  | 675.1|
|Methane 	| -161.5 	  | -258.69|
|Methanol	| 66    	  | 151|
|Propane 	| -42.04 	  | -43.67|
|Sulfuric Acid 	| 330 	  | 626|
|Water 	    |100 	      | 212|

This table can be converted into a Pandas Dataframe using a python dictionary as an entry.


```python
temps={'F': [-84, -35.5, 78.4, 80.3, 356.9, -161.5, 66, -42.04, 330, 100], 
       'C':[-119,-28.1, 173, 177, 675.1, -258.69, 151, -43.67, 626, 212]}
```


```python
pd.DataFrame(temps)
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>F</th>
      <th>C</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>-84.00</td>
      <td>-119.00</td>
    </tr>
    <tr>
      <th>1</th>
      <td>-35.50</td>
      <td>-28.10</td>
    </tr>
    <tr>
      <th>2</th>
      <td>78.40</td>
      <td>173.00</td>
    </tr>
    <tr>
      <th>3</th>
      <td>80.30</td>
      <td>177.00</td>
    </tr>
    <tr>
      <th>4</th>
      <td>356.90</td>
      <td>675.10</td>
    </tr>
    <tr>
      <th>5</th>
      <td>-161.50</td>
      <td>-258.69</td>
    </tr>
    <tr>
      <th>6</th>
      <td>66.00</td>
      <td>151.00</td>
    </tr>
    <tr>
      <th>7</th>
      <td>-42.04</td>
      <td>-43.67</td>
    </tr>
    <tr>
      <th>8</th>
      <td>330.00</td>
      <td>626.00</td>
    </tr>
    <tr>
      <th>9</th>
      <td>100.00</td>
      <td>212.00</td>
    </tr>
  </tbody>
</table>
</div>



**How did that work?**

Each *(key, value)* item in `temps` corresponds to a *column* in the resulting DataFrame.

The **Index** of this DataFrame was given to us on creation as the numbers 0-9.
To complete the table, let's add the names of the substances for which the boiling point was measured.


```python
indices=['Acetylene', 'Ammonia', 'Ethanol', 'Isopropyl Alchol', 
         'Mercury', 'Methane', 'Methanol', 'Propane', 'Sulfuric Acid', 'Water']
```


```python
boiling = pd.DataFrame(temps, index=indices)
boiling
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>F</th>
      <th>C</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>Acetylene</th>
      <td>-84.00</td>
      <td>-119.00</td>
    </tr>
    <tr>
      <th>Ammonia</th>
      <td>-35.50</td>
      <td>-28.10</td>
    </tr>
    <tr>
      <th>Ethanol</th>
      <td>78.40</td>
      <td>173.00</td>
    </tr>
    <tr>
      <th>Isopropyl Alchol</th>
      <td>80.30</td>
      <td>177.00</td>
    </tr>
    <tr>
      <th>Mercury</th>
      <td>356.90</td>
      <td>675.10</td>
    </tr>
    <tr>
      <th>Methane</th>
      <td>-161.50</td>
      <td>-258.69</td>
    </tr>
    <tr>
      <th>Methanol</th>
      <td>66.00</td>
      <td>151.00</td>
    </tr>
    <tr>
      <th>Propane</th>
      <td>-42.04</td>
      <td>-43.67</td>
    </tr>
    <tr>
      <th>Sulfuric Acid</th>
      <td>330.00</td>
      <td>626.00</td>
    </tr>
    <tr>
      <th>Water</th>
      <td>100.00</td>
      <td>212.00</td>
    </tr>
  </tbody>
</table>
</div>



A pandas data frame arranges data into columns and rows, each column has a tag and each row is identified with an index. If the index is not declared, a number will be used instead.

Before we now play with the data, I would like to stress that one of the differences with NumPy is how we want to manage missing data. Let's see two examples

## Extracting columns and rows

Columns can be extracted using the name of the column, there are two ways of extracting them, as series or as another data frame. As Series will be:


```python
boiling['F']
```




    Acetylene           -84.00
    Ammonia             -35.50
    Ethanol              78.40
    Isopropyl Alchol     80.30
    Mercury             356.90
    Methane            -161.50
    Methanol             66.00
    Propane             -42.04
    Sulfuric Acid       330.00
    Water               100.00
    Name: F, dtype: float64




```python
type(_)
```




    pandas.core.series.Series



As data frame, a double bracket is used


```python
boiling[['F']]
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>F</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>Acetylene</th>
      <td>-84.00</td>
    </tr>
    <tr>
      <th>Ammonia</th>
      <td>-35.50</td>
    </tr>
    <tr>
      <th>Ethanol</th>
      <td>78.40</td>
    </tr>
    <tr>
      <th>Isopropyl Alchol</th>
      <td>80.30</td>
    </tr>
    <tr>
      <th>Mercury</th>
      <td>356.90</td>
    </tr>
    <tr>
      <th>Methane</th>
      <td>-161.50</td>
    </tr>
    <tr>
      <th>Methanol</th>
      <td>66.00</td>
    </tr>
    <tr>
      <th>Propane</th>
      <td>-42.04</td>
    </tr>
    <tr>
      <th>Sulfuric Acid</th>
      <td>330.00</td>
    </tr>
    <tr>
      <th>Water</th>
      <td>100.00</td>
    </tr>
  </tbody>
</table>
</div>




```python
type(_)
```




    pandas.core.frame.DataFrame



Rows are extracted with the method loc, for example:


```python
boiling.loc['Water']
```




    F    100.0
    C    212.0
    Name: Water, dtype: float64




```python
type(_)
```




    pandas.core.series.Series



The row can also be returned as a DataFrame using the double bracket notation.


```python
boiling.loc[['Water']] 
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>F</th>
      <th>C</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>Water</th>
      <td>100.0</td>
      <td>212.0</td>
    </tr>
  </tbody>
</table>
</div>



There is another way of extracting columns with a dot notation. It takes the flexibility of Python, pandas is also able to convert the columns as public attributes of the data frame object. Consider this example:


```python
boiling.C
```




    Acetylene          -119.00
    Ammonia             -28.10
    Ethanol             173.00
    Isopropyl Alchol    177.00
    Mercury             675.10
    Methane            -258.69
    Methanol            151.00
    Propane             -43.67
    Sulfuric Acid       626.00
    Water               212.00
    Name: C, dtype: float64




```python
type(_)
```




    pandas.core.series.Series



The (dot) notation only works if the names of the columns have no spaces, otherwise only the bracket column extraction applies.


```python
df=pd.DataFrame({'case one': [1], 'case two': [2]})
```


```python
df['case one']
```




    0    1
    Name: case one, dtype: int64



The location and extraction methods in Pandas are far more elaborated than just the examples above. Most data frames that are created in actual applications are not created from dictionaries but actual files.

## Read data

It’s quite simple to load data from various file formats into a DataFrame. In the following examples, we'll create data frames from several usual formats.

### From CSV files

CSV stands for "comma-separated values". Its data fields are most often separated, or delimited, by a comma. For example, let's say you had a spreadsheet containing the following data.

CSV is a simple file format used to store tabular data, such as a spreadsheet or one table from a relational database. Files in the CSV format can be imported to and exported from programs that store data in tables, such as Microsoft Excel or OpenOffice Calc.

Being a text file, this format is not recommended when dealing with extremely large tables or more complex data structures, due to the natural limitations of the text format.


```python
df = pd.read_csv('data/heart.csv')
```

This is a table downloaded from <https://www.kaggle.com/ronitf/heart-disease-uci>. The table contains several columns related to the presence of heart disease in a list of patients. In real applications, tables can be extremely large to be seen as complete. Pandas offer a few methods to get a quick overview of the contents of a DataFrame


```python
df.head(10)
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>age</th>
      <th>sex</th>
      <th>cp</th>
      <th>trestbps</th>
      <th>chol</th>
      <th>fbs</th>
      <th>restecg</th>
      <th>thalach</th>
      <th>exang</th>
      <th>oldpeak</th>
      <th>slope</th>
      <th>ca</th>
      <th>thal</th>
      <th>target</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>63</td>
      <td>1</td>
      <td>3</td>
      <td>145</td>
      <td>233</td>
      <td>1</td>
      <td>0</td>
      <td>150</td>
      <td>0</td>
      <td>2.3</td>
      <td>0</td>
      <td>0</td>
      <td>1</td>
      <td>1</td>
    </tr>
    <tr>
      <th>1</th>
      <td>37</td>
      <td>1</td>
      <td>2</td>
      <td>130</td>
      <td>250</td>
      <td>0</td>
      <td>1</td>
      <td>187</td>
      <td>0</td>
      <td>3.5</td>
      <td>0</td>
      <td>0</td>
      <td>2</td>
      <td>1</td>
    </tr>
    <tr>
      <th>2</th>
      <td>41</td>
      <td>0</td>
      <td>1</td>
      <td>130</td>
      <td>204</td>
      <td>0</td>
      <td>0</td>
      <td>172</td>
      <td>0</td>
      <td>1.4</td>
      <td>2</td>
      <td>0</td>
      <td>2</td>
      <td>1</td>
    </tr>
    <tr>
      <th>3</th>
      <td>56</td>
      <td>1</td>
      <td>1</td>
      <td>120</td>
      <td>236</td>
      <td>0</td>
      <td>1</td>
      <td>178</td>
      <td>0</td>
      <td>0.8</td>
      <td>2</td>
      <td>0</td>
      <td>2</td>
      <td>1</td>
    </tr>
    <tr>
      <th>4</th>
      <td>57</td>
      <td>0</td>
      <td>0</td>
      <td>120</td>
      <td>354</td>
      <td>0</td>
      <td>1</td>
      <td>163</td>
      <td>1</td>
      <td>0.6</td>
      <td>2</td>
      <td>0</td>
      <td>2</td>
      <td>1</td>
    </tr>
    <tr>
      <th>5</th>
      <td>57</td>
      <td>1</td>
      <td>0</td>
      <td>140</td>
      <td>192</td>
      <td>0</td>
      <td>1</td>
      <td>148</td>
      <td>0</td>
      <td>0.4</td>
      <td>1</td>
      <td>0</td>
      <td>1</td>
      <td>1</td>
    </tr>
    <tr>
      <th>6</th>
      <td>56</td>
      <td>0</td>
      <td>1</td>
      <td>140</td>
      <td>294</td>
      <td>0</td>
      <td>0</td>
      <td>153</td>
      <td>0</td>
      <td>1.3</td>
      <td>1</td>
      <td>0</td>
      <td>2</td>
      <td>1</td>
    </tr>
    <tr>
      <th>7</th>
      <td>44</td>
      <td>1</td>
      <td>1</td>
      <td>120</td>
      <td>263</td>
      <td>0</td>
      <td>1</td>
      <td>173</td>
      <td>0</td>
      <td>0.0</td>
      <td>2</td>
      <td>0</td>
      <td>3</td>
      <td>1</td>
    </tr>
    <tr>
      <th>8</th>
      <td>52</td>
      <td>1</td>
      <td>2</td>
      <td>172</td>
      <td>199</td>
      <td>1</td>
      <td>1</td>
      <td>162</td>
      <td>0</td>
      <td>0.5</td>
      <td>2</td>
      <td>0</td>
      <td>3</td>
      <td>1</td>
    </tr>
    <tr>
      <th>9</th>
      <td>57</td>
      <td>1</td>
      <td>2</td>
      <td>150</td>
      <td>168</td>
      <td>0</td>
      <td>1</td>
      <td>174</td>
      <td>0</td>
      <td>1.6</td>
      <td>2</td>
      <td>0</td>
      <td>2</td>
      <td>1</td>
    </tr>
  </tbody>
</table>
</div>




```python
df.tail(10)
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>age</th>
      <th>sex</th>
      <th>cp</th>
      <th>trestbps</th>
      <th>chol</th>
      <th>fbs</th>
      <th>restecg</th>
      <th>thalach</th>
      <th>exang</th>
      <th>oldpeak</th>
      <th>slope</th>
      <th>ca</th>
      <th>thal</th>
      <th>target</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>293</th>
      <td>67</td>
      <td>1</td>
      <td>2</td>
      <td>152</td>
      <td>212</td>
      <td>0</td>
      <td>0</td>
      <td>150</td>
      <td>0</td>
      <td>0.8</td>
      <td>1</td>
      <td>0</td>
      <td>3</td>
      <td>0</td>
    </tr>
    <tr>
      <th>294</th>
      <td>44</td>
      <td>1</td>
      <td>0</td>
      <td>120</td>
      <td>169</td>
      <td>0</td>
      <td>1</td>
      <td>144</td>
      <td>1</td>
      <td>2.8</td>
      <td>0</td>
      <td>0</td>
      <td>1</td>
      <td>0</td>
    </tr>
    <tr>
      <th>295</th>
      <td>63</td>
      <td>1</td>
      <td>0</td>
      <td>140</td>
      <td>187</td>
      <td>0</td>
      <td>0</td>
      <td>144</td>
      <td>1</td>
      <td>4.0</td>
      <td>2</td>
      <td>2</td>
      <td>3</td>
      <td>0</td>
    </tr>
    <tr>
      <th>296</th>
      <td>63</td>
      <td>0</td>
      <td>0</td>
      <td>124</td>
      <td>197</td>
      <td>0</td>
      <td>1</td>
      <td>136</td>
      <td>1</td>
      <td>0.0</td>
      <td>1</td>
      <td>0</td>
      <td>2</td>
      <td>0</td>
    </tr>
    <tr>
      <th>297</th>
      <td>59</td>
      <td>1</td>
      <td>0</td>
      <td>164</td>
      <td>176</td>
      <td>1</td>
      <td>0</td>
      <td>90</td>
      <td>0</td>
      <td>1.0</td>
      <td>1</td>
      <td>2</td>
      <td>1</td>
      <td>0</td>
    </tr>
    <tr>
      <th>298</th>
      <td>57</td>
      <td>0</td>
      <td>0</td>
      <td>140</td>
      <td>241</td>
      <td>0</td>
      <td>1</td>
      <td>123</td>
      <td>1</td>
      <td>0.2</td>
      <td>1</td>
      <td>0</td>
      <td>3</td>
      <td>0</td>
    </tr>
    <tr>
      <th>299</th>
      <td>45</td>
      <td>1</td>
      <td>3</td>
      <td>110</td>
      <td>264</td>
      <td>0</td>
      <td>1</td>
      <td>132</td>
      <td>0</td>
      <td>1.2</td>
      <td>1</td>
      <td>0</td>
      <td>3</td>
      <td>0</td>
    </tr>
    <tr>
      <th>300</th>
      <td>68</td>
      <td>1</td>
      <td>0</td>
      <td>144</td>
      <td>193</td>
      <td>1</td>
      <td>1</td>
      <td>141</td>
      <td>0</td>
      <td>3.4</td>
      <td>1</td>
      <td>2</td>
      <td>3</td>
      <td>0</td>
    </tr>
    <tr>
      <th>301</th>
      <td>57</td>
      <td>1</td>
      <td>0</td>
      <td>130</td>
      <td>131</td>
      <td>0</td>
      <td>1</td>
      <td>115</td>
      <td>1</td>
      <td>1.2</td>
      <td>1</td>
      <td>1</td>
      <td>3</td>
      <td>0</td>
    </tr>
    <tr>
      <th>302</th>
      <td>57</td>
      <td>0</td>
      <td>1</td>
      <td>130</td>
      <td>236</td>
      <td>0</td>
      <td>0</td>
      <td>174</td>
      <td>0</td>
      <td>0.0</td>
      <td>1</td>
      <td>1</td>
      <td>2</td>
      <td>0</td>
    </tr>
  </tbody>
</table>
</div>




```python
df.shape
```




    (303, 14)




```python
df.size
```




    4242




```python
df.loc[:,['age', 'sex']]
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>age</th>
      <th>sex</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>63</td>
      <td>1</td>
    </tr>
    <tr>
      <th>1</th>
      <td>37</td>
      <td>1</td>
    </tr>
    <tr>
      <th>2</th>
      <td>41</td>
      <td>0</td>
    </tr>
    <tr>
      <th>3</th>
      <td>56</td>
      <td>1</td>
    </tr>
    <tr>
      <th>4</th>
      <td>57</td>
      <td>0</td>
    </tr>
    <tr>
      <th>...</th>
      <td>...</td>
      <td>...</td>
    </tr>
    <tr>
      <th>298</th>
      <td>57</td>
      <td>0</td>
    </tr>
    <tr>
      <th>299</th>
      <td>45</td>
      <td>1</td>
    </tr>
    <tr>
      <th>300</th>
      <td>68</td>
      <td>1</td>
    </tr>
    <tr>
      <th>301</th>
      <td>57</td>
      <td>1</td>
    </tr>
    <tr>
      <th>302</th>
      <td>57</td>
      <td>0</td>
    </tr>
  </tbody>
</table>
<p>303 rows × 2 columns</p>
</div>




```python
# adding a new column
df["new column"]=None
df.head()
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>age</th>
      <th>sex</th>
      <th>cp</th>
      <th>trestbps</th>
      <th>chol</th>
      <th>fbs</th>
      <th>restecg</th>
      <th>thalach</th>
      <th>exang</th>
      <th>oldpeak</th>
      <th>slope</th>
      <th>ca</th>
      <th>thal</th>
      <th>target</th>
      <th>new column</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>63</td>
      <td>1</td>
      <td>3</td>
      <td>145</td>
      <td>233</td>
      <td>1</td>
      <td>0</td>
      <td>150</td>
      <td>0</td>
      <td>2.3</td>
      <td>0</td>
      <td>0</td>
      <td>1</td>
      <td>1</td>
      <td>None</td>
    </tr>
    <tr>
      <th>1</th>
      <td>37</td>
      <td>1</td>
      <td>2</td>
      <td>130</td>
      <td>250</td>
      <td>0</td>
      <td>1</td>
      <td>187</td>
      <td>0</td>
      <td>3.5</td>
      <td>0</td>
      <td>0</td>
      <td>2</td>
      <td>1</td>
      <td>None</td>
    </tr>
    <tr>
      <th>2</th>
      <td>41</td>
      <td>0</td>
      <td>1</td>
      <td>130</td>
      <td>204</td>
      <td>0</td>
      <td>0</td>
      <td>172</td>
      <td>0</td>
      <td>1.4</td>
      <td>2</td>
      <td>0</td>
      <td>2</td>
      <td>1</td>
      <td>None</td>
    </tr>
    <tr>
      <th>3</th>
      <td>56</td>
      <td>1</td>
      <td>1</td>
      <td>120</td>
      <td>236</td>
      <td>0</td>
      <td>1</td>
      <td>178</td>
      <td>0</td>
      <td>0.8</td>
      <td>2</td>
      <td>0</td>
      <td>2</td>
      <td>1</td>
      <td>None</td>
    </tr>
    <tr>
      <th>4</th>
      <td>57</td>
      <td>0</td>
      <td>0</td>
      <td>120</td>
      <td>354</td>
      <td>0</td>
      <td>1</td>
      <td>163</td>
      <td>1</td>
      <td>0.6</td>
      <td>2</td>
      <td>0</td>
      <td>2</td>
      <td>1</td>
      <td>None</td>
    </tr>
  </tbody>
</table>
</div>




```python
# dropping one column (also works with rows)
del df["new column"]
df.head()
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>age</th>
      <th>sex</th>
      <th>cp</th>
      <th>trestbps</th>
      <th>chol</th>
      <th>fbs</th>
      <th>restecg</th>
      <th>thalach</th>
      <th>exang</th>
      <th>oldpeak</th>
      <th>slope</th>
      <th>ca</th>
      <th>thal</th>
      <th>target</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>63</td>
      <td>1</td>
      <td>3</td>
      <td>145</td>
      <td>233</td>
      <td>1</td>
      <td>0</td>
      <td>150</td>
      <td>0</td>
      <td>2.3</td>
      <td>0</td>
      <td>0</td>
      <td>1</td>
      <td>1</td>
    </tr>
    <tr>
      <th>1</th>
      <td>37</td>
      <td>1</td>
      <td>2</td>
      <td>130</td>
      <td>250</td>
      <td>0</td>
      <td>1</td>
      <td>187</td>
      <td>0</td>
      <td>3.5</td>
      <td>0</td>
      <td>0</td>
      <td>2</td>
      <td>1</td>
    </tr>
    <tr>
      <th>2</th>
      <td>41</td>
      <td>0</td>
      <td>1</td>
      <td>130</td>
      <td>204</td>
      <td>0</td>
      <td>0</td>
      <td>172</td>
      <td>0</td>
      <td>1.4</td>
      <td>2</td>
      <td>0</td>
      <td>2</td>
      <td>1</td>
    </tr>
    <tr>
      <th>3</th>
      <td>56</td>
      <td>1</td>
      <td>1</td>
      <td>120</td>
      <td>236</td>
      <td>0</td>
      <td>1</td>
      <td>178</td>
      <td>0</td>
      <td>0.8</td>
      <td>2</td>
      <td>0</td>
      <td>2</td>
      <td>1</td>
    </tr>
    <tr>
      <th>4</th>
      <td>57</td>
      <td>0</td>
      <td>0</td>
      <td>120</td>
      <td>354</td>
      <td>0</td>
      <td>1</td>
      <td>163</td>
      <td>1</td>
      <td>0.6</td>
      <td>2</td>
      <td>0</td>
      <td>2</td>
      <td>1</td>
    </tr>
  </tbody>
</table>
</div>




```python
# Becareful if you make copies and modify the data
df1=df["age"]
df1 += 1
df.head()
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>age</th>
      <th>sex</th>
      <th>cp</th>
      <th>trestbps</th>
      <th>chol</th>
      <th>fbs</th>
      <th>restecg</th>
      <th>thalach</th>
      <th>exang</th>
      <th>oldpeak</th>
      <th>slope</th>
      <th>ca</th>
      <th>thal</th>
      <th>target</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>64</td>
      <td>1</td>
      <td>3</td>
      <td>145</td>
      <td>233</td>
      <td>1</td>
      <td>0</td>
      <td>150</td>
      <td>0</td>
      <td>2.3</td>
      <td>0</td>
      <td>0</td>
      <td>1</td>
      <td>1</td>
    </tr>
    <tr>
      <th>1</th>
      <td>38</td>
      <td>1</td>
      <td>2</td>
      <td>130</td>
      <td>250</td>
      <td>0</td>
      <td>1</td>
      <td>187</td>
      <td>0</td>
      <td>3.5</td>
      <td>0</td>
      <td>0</td>
      <td>2</td>
      <td>1</td>
    </tr>
    <tr>
      <th>2</th>
      <td>42</td>
      <td>0</td>
      <td>1</td>
      <td>130</td>
      <td>204</td>
      <td>0</td>
      <td>0</td>
      <td>172</td>
      <td>0</td>
      <td>1.4</td>
      <td>2</td>
      <td>0</td>
      <td>2</td>
      <td>1</td>
    </tr>
    <tr>
      <th>3</th>
      <td>57</td>
      <td>1</td>
      <td>1</td>
      <td>120</td>
      <td>236</td>
      <td>0</td>
      <td>1</td>
      <td>178</td>
      <td>0</td>
      <td>0.8</td>
      <td>2</td>
      <td>0</td>
      <td>2</td>
      <td>1</td>
    </tr>
    <tr>
      <th>4</th>
      <td>58</td>
      <td>0</td>
      <td>0</td>
      <td>120</td>
      <td>354</td>
      <td>0</td>
      <td>1</td>
      <td>163</td>
      <td>1</td>
      <td>0.6</td>
      <td>2</td>
      <td>0</td>
      <td>2</td>
      <td>1</td>
    </tr>
  </tbody>
</table>
</div>




```python
# if you are not in windows. you can communicate with the operating system
!cat data/heart.csv
```

    age,sex,cp,trestbps,chol,fbs,restecg,thalach,exang,oldpeak,slope,ca,thal,target
    63,1,3,145,233,1,0,150,0,2.3,0,0,1,1
    37,1,2,130,250,0,1,187,0,3.5,0,0,2,1
    41,0,1,130,204,0,0,172,0,1.4,2,0,2,1
    56,1,1,120,236,0,1,178,0,0.8,2,0,2,1
    57,0,0,120,354,0,1,163,1,0.6,2,0,2,1
    57,1,0,140,192,0,1,148,0,0.4,1,0,1,1
    56,0,1,140,294,0,0,153,0,1.3,1,0,2,1
    44,1,1,120,263,0,1,173,0,0,2,0,3,1
    52,1,2,172,199,1,1,162,0,0.5,2,0,3,1
    57,1,2,150,168,0,1,174,0,1.6,2,0,2,1
    54,1,0,140,239,0,1,160,0,1.2,2,0,2,1
    48,0,2,130,275,0,1,139,0,0.2,2,0,2,1
    49,1,1,130,266,0,1,171,0,0.6,2,0,2,1
    64,1,3,110,211,0,0,144,1,1.8,1,0,2,1
    58,0,3,150,283,1,0,162,0,1,2,0,2,1
    50,0,2,120,219,0,1,158,0,1.6,1,0,2,1
    58,0,2,120,340,0,1,172,0,0,2,0,2,1
    66,0,3,150,226,0,1,114,0,2.6,0,0,2,1
    43,1,0,150,247,0,1,171,0,1.5,2,0,2,1
    69,0,3,140,239,0,1,151,0,1.8,2,2,2,1
    59,1,0,135,234,0,1,161,0,0.5,1,0,3,1
    44,1,2,130,233,0,1,179,1,0.4,2,0,2,1
    42,1,0,140,226,0,1,178,0,0,2,0,2,1
    61,1,2,150,243,1,1,137,1,1,1,0,2,1
    40,1,3,140,199,0,1,178,1,1.4,2,0,3,1
    71,0,1,160,302,0,1,162,0,0.4,2,2,2,1
    59,1,2,150,212,1,1,157,0,1.6,2,0,2,1
    51,1,2,110,175,0,1,123,0,0.6,2,0,2,1
    65,0,2,140,417,1,0,157,0,0.8,2,1,2,1
    53,1,2,130,197,1,0,152,0,1.2,0,0,2,1
    41,0,1,105,198,0,1,168,0,0,2,1,2,1
    65,1,0,120,177,0,1,140,0,0.4,2,0,3,1
    44,1,1,130,219,0,0,188,0,0,2,0,2,1
    54,1,2,125,273,0,0,152,0,0.5,0,1,2,1
    51,1,3,125,213,0,0,125,1,1.4,2,1,2,1
    46,0,2,142,177,0,0,160,1,1.4,0,0,2,1
    54,0,2,135,304,1,1,170,0,0,2,0,2,1
    54,1,2,150,232,0,0,165,0,1.6,2,0,3,1
    65,0,2,155,269,0,1,148,0,0.8,2,0,2,1
    65,0,2,160,360,0,0,151,0,0.8,2,0,2,1
    51,0,2,140,308,0,0,142,0,1.5,2,1,2,1
    48,1,1,130,245,0,0,180,0,0.2,1,0,2,1
    45,1,0,104,208,0,0,148,1,3,1,0,2,1
    53,0,0,130,264,0,0,143,0,0.4,1,0,2,1
    39,1,2,140,321,0,0,182,0,0,2,0,2,1
    52,1,1,120,325,0,1,172,0,0.2,2,0,2,1
    44,1,2,140,235,0,0,180,0,0,2,0,2,1
    47,1,2,138,257,0,0,156,0,0,2,0,2,1
    53,0,2,128,216,0,0,115,0,0,2,0,0,1
    53,0,0,138,234,0,0,160,0,0,2,0,2,1
    51,0,2,130,256,0,0,149,0,0.5,2,0,2,1
    66,1,0,120,302,0,0,151,0,0.4,1,0,2,1
    62,1,2,130,231,0,1,146,0,1.8,1,3,3,1
    44,0,2,108,141,0,1,175,0,0.6,1,0,2,1
    63,0,2,135,252,0,0,172,0,0,2,0,2,1
    52,1,1,134,201,0,1,158,0,0.8,2,1,2,1
    48,1,0,122,222,0,0,186,0,0,2,0,2,1
    45,1,0,115,260,0,0,185,0,0,2,0,2,1
    34,1,3,118,182,0,0,174,0,0,2,0,2,1
    57,0,0,128,303,0,0,159,0,0,2,1,2,1
    71,0,2,110,265,1,0,130,0,0,2,1,2,1
    54,1,1,108,309,0,1,156,0,0,2,0,3,1
    52,1,3,118,186,0,0,190,0,0,1,0,1,1
    41,1,1,135,203,0,1,132,0,0,1,0,1,1
    58,1,2,140,211,1,0,165,0,0,2,0,2,1
    35,0,0,138,183,0,1,182,0,1.4,2,0,2,1
    51,1,2,100,222,0,1,143,1,1.2,1,0,2,1
    45,0,1,130,234,0,0,175,0,0.6,1,0,2,1
    44,1,1,120,220,0,1,170,0,0,2,0,2,1
    62,0,0,124,209,0,1,163,0,0,2,0,2,1
    54,1,2,120,258,0,0,147,0,0.4,1,0,3,1
    51,1,2,94,227,0,1,154,1,0,2,1,3,1
    29,1,1,130,204,0,0,202,0,0,2,0,2,1
    51,1,0,140,261,0,0,186,1,0,2,0,2,1
    43,0,2,122,213,0,1,165,0,0.2,1,0,2,1
    55,0,1,135,250,0,0,161,0,1.4,1,0,2,1
    51,1,2,125,245,1,0,166,0,2.4,1,0,2,1
    59,1,1,140,221,0,1,164,1,0,2,0,2,1
    52,1,1,128,205,1,1,184,0,0,2,0,2,1
    58,1,2,105,240,0,0,154,1,0.6,1,0,3,1
    41,1,2,112,250,0,1,179,0,0,2,0,2,1
    45,1,1,128,308,0,0,170,0,0,2,0,2,1
    60,0,2,102,318,0,1,160,0,0,2,1,2,1
    52,1,3,152,298,1,1,178,0,1.2,1,0,3,1
    42,0,0,102,265,0,0,122,0,0.6,1,0,2,1
    67,0,2,115,564,0,0,160,0,1.6,1,0,3,1
    68,1,2,118,277,0,1,151,0,1,2,1,3,1
    46,1,1,101,197,1,1,156,0,0,2,0,3,1
    54,0,2,110,214,0,1,158,0,1.6,1,0,2,1
    58,0,0,100,248,0,0,122,0,1,1,0,2,1
    48,1,2,124,255,1,1,175,0,0,2,2,2,1
    57,1,0,132,207,0,1,168,1,0,2,0,3,1
    52,1,2,138,223,0,1,169,0,0,2,4,2,1
    54,0,1,132,288,1,0,159,1,0,2,1,2,1
    45,0,1,112,160,0,1,138,0,0,1,0,2,1
    53,1,0,142,226,0,0,111,1,0,2,0,3,1
    62,0,0,140,394,0,0,157,0,1.2,1,0,2,1
    52,1,0,108,233,1,1,147,0,0.1,2,3,3,1
    43,1,2,130,315,0,1,162,0,1.9,2,1,2,1
    53,1,2,130,246,1,0,173,0,0,2,3,2,1
    42,1,3,148,244,0,0,178,0,0.8,2,2,2,1
    59,1,3,178,270,0,0,145,0,4.2,0,0,3,1
    63,0,1,140,195,0,1,179,0,0,2,2,2,1
    42,1,2,120,240,1,1,194,0,0.8,0,0,3,1
    50,1,2,129,196,0,1,163,0,0,2,0,2,1
    68,0,2,120,211,0,0,115,0,1.5,1,0,2,1
    69,1,3,160,234,1,0,131,0,0.1,1,1,2,1
    45,0,0,138,236,0,0,152,1,0.2,1,0,2,1
    50,0,1,120,244,0,1,162,0,1.1,2,0,2,1
    50,0,0,110,254,0,0,159,0,0,2,0,2,1
    64,0,0,180,325,0,1,154,1,0,2,0,2,1
    57,1,2,150,126,1,1,173,0,0.2,2,1,3,1
    64,0,2,140,313,0,1,133,0,0.2,2,0,3,1
    43,1,0,110,211,0,1,161,0,0,2,0,3,1
    55,1,1,130,262,0,1,155,0,0,2,0,2,1
    37,0,2,120,215,0,1,170,0,0,2,0,2,1
    41,1,2,130,214,0,0,168,0,2,1,0,2,1
    56,1,3,120,193,0,0,162,0,1.9,1,0,3,1
    46,0,1,105,204,0,1,172,0,0,2,0,2,1
    46,0,0,138,243,0,0,152,1,0,1,0,2,1
    64,0,0,130,303,0,1,122,0,2,1,2,2,1
    59,1,0,138,271,0,0,182,0,0,2,0,2,1
    41,0,2,112,268,0,0,172,1,0,2,0,2,1
    54,0,2,108,267,0,0,167,0,0,2,0,2,1
    39,0,2,94,199,0,1,179,0,0,2,0,2,1
    34,0,1,118,210,0,1,192,0,0.7,2,0,2,1
    47,1,0,112,204,0,1,143,0,0.1,2,0,2,1
    67,0,2,152,277,0,1,172,0,0,2,1,2,1
    52,0,2,136,196,0,0,169,0,0.1,1,0,2,1
    74,0,1,120,269,0,0,121,1,0.2,2,1,2,1
    54,0,2,160,201,0,1,163,0,0,2,1,2,1
    49,0,1,134,271,0,1,162,0,0,1,0,2,1
    42,1,1,120,295,0,1,162,0,0,2,0,2,1
    41,1,1,110,235,0,1,153,0,0,2,0,2,1
    41,0,1,126,306,0,1,163,0,0,2,0,2,1
    49,0,0,130,269,0,1,163,0,0,2,0,2,1
    60,0,2,120,178,1,1,96,0,0,2,0,2,1
    62,1,1,128,208,1,0,140,0,0,2,0,2,1
    57,1,0,110,201,0,1,126,1,1.5,1,0,1,1
    64,1,0,128,263,0,1,105,1,0.2,1,1,3,1
    51,0,2,120,295,0,0,157,0,0.6,2,0,2,1
    43,1,0,115,303,0,1,181,0,1.2,1,0,2,1
    42,0,2,120,209,0,1,173,0,0,1,0,2,1
    67,0,0,106,223,0,1,142,0,0.3,2,2,2,1
    76,0,2,140,197,0,2,116,0,1.1,1,0,2,1
    70,1,1,156,245,0,0,143,0,0,2,0,2,1
    44,0,2,118,242,0,1,149,0,0.3,1,1,2,1
    60,0,3,150,240,0,1,171,0,0.9,2,0,2,1
    44,1,2,120,226,0,1,169,0,0,2,0,2,1
    42,1,2,130,180,0,1,150,0,0,2,0,2,1
    66,1,0,160,228,0,0,138,0,2.3,2,0,1,1
    71,0,0,112,149,0,1,125,0,1.6,1,0,2,1
    64,1,3,170,227,0,0,155,0,0.6,1,0,3,1
    66,0,2,146,278,0,0,152,0,0,1,1,2,1
    39,0,2,138,220,0,1,152,0,0,1,0,2,1
    58,0,0,130,197,0,1,131,0,0.6,1,0,2,1
    47,1,2,130,253,0,1,179,0,0,2,0,2,1
    35,1,1,122,192,0,1,174,0,0,2,0,2,1
    58,1,1,125,220,0,1,144,0,0.4,1,4,3,1
    56,1,1,130,221,0,0,163,0,0,2,0,3,1
    56,1,1,120,240,0,1,169,0,0,0,0,2,1
    55,0,1,132,342,0,1,166,0,1.2,2,0,2,1
    41,1,1,120,157,0,1,182,0,0,2,0,2,1
    38,1,2,138,175,0,1,173,0,0,2,4,2,1
    38,1,2,138,175,0,1,173,0,0,2,4,2,1
    67,1,0,160,286,0,0,108,1,1.5,1,3,2,0
    67,1,0,120,229,0,0,129,1,2.6,1,2,3,0
    62,0,0,140,268,0,0,160,0,3.6,0,2,2,0
    63,1,0,130,254,0,0,147,0,1.4,1,1,3,0
    53,1,0,140,203,1,0,155,1,3.1,0,0,3,0
    56,1,2,130,256,1,0,142,1,0.6,1,1,1,0
    48,1,1,110,229,0,1,168,0,1,0,0,3,0
    58,1,1,120,284,0,0,160,0,1.8,1,0,2,0
    58,1,2,132,224,0,0,173,0,3.2,2,2,3,0
    60,1,0,130,206,0,0,132,1,2.4,1,2,3,0
    40,1,0,110,167,0,0,114,1,2,1,0,3,0
    60,1,0,117,230,1,1,160,1,1.4,2,2,3,0
    64,1,2,140,335,0,1,158,0,0,2,0,2,0
    43,1,0,120,177,0,0,120,1,2.5,1,0,3,0
    57,1,0,150,276,0,0,112,1,0.6,1,1,1,0
    55,1,0,132,353,0,1,132,1,1.2,1,1,3,0
    65,0,0,150,225,0,0,114,0,1,1,3,3,0
    61,0,0,130,330,0,0,169,0,0,2,0,2,0
    58,1,2,112,230,0,0,165,0,2.5,1,1,3,0
    50,1,0,150,243,0,0,128,0,2.6,1,0,3,0
    44,1,0,112,290,0,0,153,0,0,2,1,2,0
    60,1,0,130,253,0,1,144,1,1.4,2,1,3,0
    54,1,0,124,266,0,0,109,1,2.2,1,1,3,0
    50,1,2,140,233,0,1,163,0,0.6,1,1,3,0
    41,1,0,110,172,0,0,158,0,0,2,0,3,0
    51,0,0,130,305,0,1,142,1,1.2,1,0,3,0
    58,1,0,128,216,0,0,131,1,2.2,1,3,3,0
    54,1,0,120,188,0,1,113,0,1.4,1,1,3,0
    60,1,0,145,282,0,0,142,1,2.8,1,2,3,0
    60,1,2,140,185,0,0,155,0,3,1,0,2,0
    59,1,0,170,326,0,0,140,1,3.4,0,0,3,0
    46,1,2,150,231,0,1,147,0,3.6,1,0,2,0
    67,1,0,125,254,1,1,163,0,0.2,1,2,3,0
    62,1,0,120,267,0,1,99,1,1.8,1,2,3,0
    65,1,0,110,248,0,0,158,0,0.6,2,2,1,0
    44,1,0,110,197,0,0,177,0,0,2,1,2,0
    60,1,0,125,258,0,0,141,1,2.8,1,1,3,0
    58,1,0,150,270,0,0,111,1,0.8,2,0,3,0
    68,1,2,180,274,1,0,150,1,1.6,1,0,3,0
    62,0,0,160,164,0,0,145,0,6.2,0,3,3,0
    52,1,0,128,255,0,1,161,1,0,2,1,3,0
    59,1,0,110,239,0,0,142,1,1.2,1,1,3,0
    60,0,0,150,258,0,0,157,0,2.6,1,2,3,0
    49,1,2,120,188,0,1,139,0,2,1,3,3,0
    59,1,0,140,177,0,1,162,1,0,2,1,3,0
    57,1,2,128,229,0,0,150,0,0.4,1,1,3,0
    61,1,0,120,260,0,1,140,1,3.6,1,1,3,0
    39,1,0,118,219,0,1,140,0,1.2,1,0,3,0
    61,0,0,145,307,0,0,146,1,1,1,0,3,0
    56,1,0,125,249,1,0,144,1,1.2,1,1,2,0
    43,0,0,132,341,1,0,136,1,3,1,0,3,0
    62,0,2,130,263,0,1,97,0,1.2,1,1,3,0
    63,1,0,130,330,1,0,132,1,1.8,2,3,3,0
    65,1,0,135,254,0,0,127,0,2.8,1,1,3,0
    48,1,0,130,256,1,0,150,1,0,2,2,3,0
    63,0,0,150,407,0,0,154,0,4,1,3,3,0
    55,1,0,140,217,0,1,111,1,5.6,0,0,3,0
    65,1,3,138,282,1,0,174,0,1.4,1,1,2,0
    56,0,0,200,288,1,0,133,1,4,0,2,3,0
    54,1,0,110,239,0,1,126,1,2.8,1,1,3,0
    70,1,0,145,174,0,1,125,1,2.6,0,0,3,0
    62,1,1,120,281,0,0,103,0,1.4,1,1,3,0
    35,1,0,120,198,0,1,130,1,1.6,1,0,3,0
    59,1,3,170,288,0,0,159,0,0.2,1,0,3,0
    64,1,2,125,309,0,1,131,1,1.8,1,0,3,0
    47,1,2,108,243,0,1,152,0,0,2,0,2,0
    57,1,0,165,289,1,0,124,0,1,1,3,3,0
    55,1,0,160,289,0,0,145,1,0.8,1,1,3,0
    64,1,0,120,246,0,0,96,1,2.2,0,1,2,0
    70,1,0,130,322,0,0,109,0,2.4,1,3,2,0
    51,1,0,140,299,0,1,173,1,1.6,2,0,3,0
    58,1,0,125,300,0,0,171,0,0,2,2,3,0
    60,1,0,140,293,0,0,170,0,1.2,1,2,3,0
    77,1,0,125,304,0,0,162,1,0,2,3,2,0
    35,1,0,126,282,0,0,156,1,0,2,0,3,0
    70,1,2,160,269,0,1,112,1,2.9,1,1,3,0
    59,0,0,174,249,0,1,143,1,0,1,0,2,0
    64,1,0,145,212,0,0,132,0,2,1,2,1,0
    57,1,0,152,274,0,1,88,1,1.2,1,1,3,0
    56,1,0,132,184,0,0,105,1,2.1,1,1,1,0
    48,1,0,124,274,0,0,166,0,0.5,1,0,3,0
    56,0,0,134,409,0,0,150,1,1.9,1,2,3,0
    66,1,1,160,246,0,1,120,1,0,1,3,1,0
    54,1,1,192,283,0,0,195,0,0,2,1,3,0
    69,1,2,140,254,0,0,146,0,2,1,3,3,0
    51,1,0,140,298,0,1,122,1,4.2,1,3,3,0
    43,1,0,132,247,1,0,143,1,0.1,1,4,3,0
    62,0,0,138,294,1,1,106,0,1.9,1,3,2,0
    67,1,0,100,299,0,0,125,1,0.9,1,2,2,0
    59,1,3,160,273,0,0,125,0,0,2,0,2,0
    45,1,0,142,309,0,0,147,1,0,1,3,3,0
    58,1,0,128,259,0,0,130,1,3,1,2,3,0
    50,1,0,144,200,0,0,126,1,0.9,1,0,3,0
    62,0,0,150,244,0,1,154,1,1.4,1,0,2,0
    38,1,3,120,231,0,1,182,1,3.8,1,0,3,0
    66,0,0,178,228,1,1,165,1,1,1,2,3,0
    52,1,0,112,230,0,1,160,0,0,2,1,2,0
    53,1,0,123,282,0,1,95,1,2,1,2,3,0
    63,0,0,108,269,0,1,169,1,1.8,1,2,2,0
    54,1,0,110,206,0,0,108,1,0,1,1,2,0
    66,1,0,112,212,0,0,132,1,0.1,2,1,2,0
    55,0,0,180,327,0,2,117,1,3.4,1,0,2,0
    49,1,2,118,149,0,0,126,0,0.8,2,3,2,0
    54,1,0,122,286,0,0,116,1,3.2,1,2,2,0
    56,1,0,130,283,1,0,103,1,1.6,0,0,3,0
    46,1,0,120,249,0,0,144,0,0.8,2,0,3,0
    61,1,3,134,234,0,1,145,0,2.6,1,2,2,0
    67,1,0,120,237,0,1,71,0,1,1,0,2,0
    58,1,0,100,234,0,1,156,0,0.1,2,1,3,0
    47,1,0,110,275,0,0,118,1,1,1,1,2,0
    52,1,0,125,212,0,1,168,0,1,2,2,3,0
    58,1,0,146,218,0,1,105,0,2,1,1,3,0
    57,1,1,124,261,0,1,141,0,0.3,2,0,3,0
    58,0,1,136,319,1,0,152,0,0,2,2,2,0
    61,1,0,138,166,0,0,125,1,3.6,1,1,2,0
    42,1,0,136,315,0,1,125,1,1.8,1,0,1,0
    52,1,0,128,204,1,1,156,1,1,1,0,0,0
    59,1,2,126,218,1,1,134,0,2.2,1,1,1,0
    40,1,0,152,223,0,1,181,0,0,2,0,3,0
    61,1,0,140,207,0,0,138,1,1.9,2,1,3,0
    46,1,0,140,311,0,1,120,1,1.8,1,2,3,0
    59,1,3,134,204,0,1,162,0,0.8,2,2,2,0
    57,1,1,154,232,0,0,164,0,0,2,1,2,0
    57,1,0,110,335,0,1,143,1,3,1,1,3,0
    55,0,0,128,205,0,2,130,1,2,1,1,3,0
    61,1,0,148,203,0,1,161,0,0,2,1,3,0
    58,1,0,114,318,0,2,140,0,4.4,0,3,1,0
    58,0,0,170,225,1,0,146,1,2.8,1,2,1,0
    67,1,2,152,212,0,0,150,0,0.8,1,0,3,0
    44,1,0,120,169,0,1,144,1,2.8,0,0,1,0
    63,1,0,140,187,0,0,144,1,4,2,2,3,0
    63,0,0,124,197,0,1,136,1,0,1,0,2,0
    59,1,0,164,176,1,0,90,0,1,1,2,1,0
    57,0,0,140,241,0,1,123,1,0.2,1,0,3,0
    45,1,3,110,264,0,1,132,0,1.2,1,0,3,0
    68,1,0,144,193,1,1,141,0,3.4,1,2,3,0
    57,1,0,130,131,0,1,115,1,1.2,1,1,3,0
    57,0,1,130,236,0,0,174,0,0,1,1,2,0



```python
# if you want to read the CSV file but you want to skip the first 3 lines
df = pd.read_csv('data/heart.csv',skiprows=3)
df.head()
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>41</th>
      <th>0</th>
      <th>1</th>
      <th>130</th>
      <th>204</th>
      <th>0.1</th>
      <th>0.2</th>
      <th>172</th>
      <th>0.3</th>
      <th>1.4</th>
      <th>2</th>
      <th>0.4</th>
      <th>2.1</th>
      <th>1.1</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>56</td>
      <td>1</td>
      <td>1</td>
      <td>120</td>
      <td>236</td>
      <td>0</td>
      <td>1</td>
      <td>178</td>
      <td>0</td>
      <td>0.8</td>
      <td>2</td>
      <td>0</td>
      <td>2</td>
      <td>1</td>
    </tr>
    <tr>
      <th>1</th>
      <td>57</td>
      <td>0</td>
      <td>0</td>
      <td>120</td>
      <td>354</td>
      <td>0</td>
      <td>1</td>
      <td>163</td>
      <td>1</td>
      <td>0.6</td>
      <td>2</td>
      <td>0</td>
      <td>2</td>
      <td>1</td>
    </tr>
    <tr>
      <th>2</th>
      <td>57</td>
      <td>1</td>
      <td>0</td>
      <td>140</td>
      <td>192</td>
      <td>0</td>
      <td>1</td>
      <td>148</td>
      <td>0</td>
      <td>0.4</td>
      <td>1</td>
      <td>0</td>
      <td>1</td>
      <td>1</td>
    </tr>
    <tr>
      <th>3</th>
      <td>56</td>
      <td>0</td>
      <td>1</td>
      <td>140</td>
      <td>294</td>
      <td>0</td>
      <td>0</td>
      <td>153</td>
      <td>0</td>
      <td>1.3</td>
      <td>1</td>
      <td>0</td>
      <td>2</td>
      <td>1</td>
    </tr>
    <tr>
      <th>4</th>
      <td>44</td>
      <td>1</td>
      <td>1</td>
      <td>120</td>
      <td>263</td>
      <td>0</td>
      <td>1</td>
      <td>173</td>
      <td>0</td>
      <td>0.0</td>
      <td>2</td>
      <td>0</td>
      <td>3</td>
      <td>1</td>
    </tr>
  </tbody>
</table>
</div>




```python
# if we want to use the first column as the index
df = pd.read_csv('data/heart.csv',index_col=0,skiprows=3)
df.head()
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>0</th>
      <th>1</th>
      <th>130</th>
      <th>204</th>
      <th>0.1</th>
      <th>0.2</th>
      <th>172</th>
      <th>0.3</th>
      <th>1.4</th>
      <th>2</th>
      <th>0.4</th>
      <th>2.1</th>
      <th>1.1</th>
    </tr>
    <tr>
      <th>41</th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
      <th></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>56</th>
      <td>1</td>
      <td>1</td>
      <td>120</td>
      <td>236</td>
      <td>0</td>
      <td>1</td>
      <td>178</td>
      <td>0</td>
      <td>0.8</td>
      <td>2</td>
      <td>0</td>
      <td>2</td>
      <td>1</td>
    </tr>
    <tr>
      <th>57</th>
      <td>0</td>
      <td>0</td>
      <td>120</td>
      <td>354</td>
      <td>0</td>
      <td>1</td>
      <td>163</td>
      <td>1</td>
      <td>0.6</td>
      <td>2</td>
      <td>0</td>
      <td>2</td>
      <td>1</td>
    </tr>
    <tr>
      <th>57</th>
      <td>1</td>
      <td>0</td>
      <td>140</td>
      <td>192</td>
      <td>0</td>
      <td>1</td>
      <td>148</td>
      <td>0</td>
      <td>0.4</td>
      <td>1</td>
      <td>0</td>
      <td>1</td>
      <td>1</td>
    </tr>
    <tr>
      <th>56</th>
      <td>0</td>
      <td>1</td>
      <td>140</td>
      <td>294</td>
      <td>0</td>
      <td>0</td>
      <td>153</td>
      <td>0</td>
      <td>1.3</td>
      <td>1</td>
      <td>0</td>
      <td>2</td>
      <td>1</td>
    </tr>
    <tr>
      <th>44</th>
      <td>1</td>
      <td>1</td>
      <td>120</td>
      <td>263</td>
      <td>0</td>
      <td>1</td>
      <td>173</td>
      <td>0</td>
      <td>0.0</td>
      <td>2</td>
      <td>0</td>
      <td>3</td>
      <td>1</td>
    </tr>
  </tbody>
</table>
</div>



### From JSON Files

JSON (JavaScript Object Notation) is a lightweight data-interchange format. It is easy for humans to read and write. It is easy for machines to parse and generate. It is based on a subset of the JavaScript Programming Language, Standard ECMA-262 3rd Edition - December 1999. JSON is a text format that is completely language-independent but uses conventions that are familiar to programmers of the C-family of languages, including C, C++, C#, Java, JavaScript, Perl, Python, and many others. These properties make JSON an ideal data-interchange language.

JSON is particularly useful for Data Analysis on Python as the JSON parser is part of the Standard Library and its format looks very similar to Python dictionaries. However, notice that a JSON file or JSON string is just a set of bytes that can be read as text. A python dictionary is a complete data structure. Other differences between JSON strings and dictionaries are:

 * Python's dictionary key can hash any object, and JSON can only be a string.
 * The Python dict string can be created with single or double quotation marks. When represented on the screen, single quotes are used, however, a JSON string enforces double quotation marks.
 * You can nest tuple in Python dict. JSON can only use an array.
 
In practice, that means that a JSON file can always be converted into a Python dictionary, but the reverse is not always true.


```python
df=pd.read_json("data/heart.json")
```

### From SQLite Databases

SQLite is a C-language library that implements a small, fast, self-contained, high-reliability, full-featured, SQL database engine. SQLite is the most used database engine in the world. In practice, SQLite is a serverless SQL database in a file.


```python
import sqlite3
```


```python
con = sqlite3.connect("data/heart.db")
```


```python
df = pd.read_sql_query("SELECT * FROM heart", con)
```


```python
df.head()
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>index</th>
      <th>age</th>
      <th>sex</th>
      <th>cp</th>
      <th>trestbps</th>
      <th>chol</th>
      <th>fbs</th>
      <th>restecg</th>
      <th>thalach</th>
      <th>exang</th>
      <th>oldpeak</th>
      <th>slope</th>
      <th>ca</th>
      <th>thal</th>
      <th>target</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>0</td>
      <td>63</td>
      <td>1</td>
      <td>3</td>
      <td>145</td>
      <td>233</td>
      <td>1</td>
      <td>0</td>
      <td>150</td>
      <td>0</td>
      <td>2.3</td>
      <td>0</td>
      <td>0</td>
      <td>1</td>
      <td>1</td>
    </tr>
    <tr>
      <th>1</th>
      <td>1</td>
      <td>37</td>
      <td>1</td>
      <td>2</td>
      <td>130</td>
      <td>250</td>
      <td>0</td>
      <td>1</td>
      <td>187</td>
      <td>0</td>
      <td>3.5</td>
      <td>0</td>
      <td>0</td>
      <td>2</td>
      <td>1</td>
    </tr>
    <tr>
      <th>2</th>
      <td>2</td>
      <td>41</td>
      <td>0</td>
      <td>1</td>
      <td>130</td>
      <td>204</td>
      <td>0</td>
      <td>0</td>
      <td>172</td>
      <td>0</td>
      <td>1.4</td>
      <td>2</td>
      <td>0</td>
      <td>2</td>
      <td>1</td>
    </tr>
    <tr>
      <th>3</th>
      <td>3</td>
      <td>56</td>
      <td>1</td>
      <td>1</td>
      <td>120</td>
      <td>236</td>
      <td>0</td>
      <td>1</td>
      <td>178</td>
      <td>0</td>
      <td>0.8</td>
      <td>2</td>
      <td>0</td>
      <td>2</td>
      <td>1</td>
    </tr>
    <tr>
      <th>4</th>
      <td>4</td>
      <td>57</td>
      <td>0</td>
      <td>0</td>
      <td>120</td>
      <td>354</td>
      <td>0</td>
      <td>1</td>
      <td>163</td>
      <td>1</td>
      <td>0.6</td>
      <td>2</td>
      <td>0</td>
      <td>2</td>
      <td>1</td>
    </tr>
  </tbody>
</table>
</div>



### From Excel files

Pandas also support reading Excel files, however, to read files from recent versions of Excel. You need to install the **xlrd** package 


```python
#pip install xlrd
```

If you are using conda, the package can be installed with:


```python
#conda install xlrd
```

After the package has been installed, pandas can read the Excel files version >= 2.0


```python
df=pd.read_excel('data/2018_all_indicators.xlsx')
```

### From other formats

Pandas is very versatile in accepting a variety of formats: STATA, SAS, HDF5 files. See <https://pandas.pydata.org/pandas-docs/stable/reference/io.html> for more information on the multiple formats supported.

## Write DataFrames

Pandas also offers the ability to store resulting DataFrames back into several formats. Consider this example:
    


```python
heart = pd.read_csv('data/heart.csv')
```

Saving the data frame in those formats execute:


```python
if os.path.isfile("new_heart.db"):
    os.remove("new_heart.db")

heart.to_csv('new_heart.csv')

heart.to_json('new_heart.json')

con = sqlite3.connect("new_heart.db")
heart.to_sql('heart', con)

os.remove("new_heart.csv")
os.remove("new_heart.json")
os.remove("new_heart.db")
```

## View the data

We already saw how to use **tail** and **head** to get a glimpse into the initial and final rows. The default is 5 rows, but the value can be modified.


```python
heart.head(3)
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>age</th>
      <th>sex</th>
      <th>cp</th>
      <th>trestbps</th>
      <th>chol</th>
      <th>fbs</th>
      <th>restecg</th>
      <th>thalach</th>
      <th>exang</th>
      <th>oldpeak</th>
      <th>slope</th>
      <th>ca</th>
      <th>thal</th>
      <th>target</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>63</td>
      <td>1</td>
      <td>3</td>
      <td>145</td>
      <td>233</td>
      <td>1</td>
      <td>0</td>
      <td>150</td>
      <td>0</td>
      <td>2.3</td>
      <td>0</td>
      <td>0</td>
      <td>1</td>
      <td>1</td>
    </tr>
    <tr>
      <th>1</th>
      <td>37</td>
      <td>1</td>
      <td>2</td>
      <td>130</td>
      <td>250</td>
      <td>0</td>
      <td>1</td>
      <td>187</td>
      <td>0</td>
      <td>3.5</td>
      <td>0</td>
      <td>0</td>
      <td>2</td>
      <td>1</td>
    </tr>
    <tr>
      <th>2</th>
      <td>41</td>
      <td>0</td>
      <td>1</td>
      <td>130</td>
      <td>204</td>
      <td>0</td>
      <td>0</td>
      <td>172</td>
      <td>0</td>
      <td>1.4</td>
      <td>2</td>
      <td>0</td>
      <td>2</td>
      <td>1</td>
    </tr>
  </tbody>
</table>
</div>




```python
heart.tail(3)
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>age</th>
      <th>sex</th>
      <th>cp</th>
      <th>trestbps</th>
      <th>chol</th>
      <th>fbs</th>
      <th>restecg</th>
      <th>thalach</th>
      <th>exang</th>
      <th>oldpeak</th>
      <th>slope</th>
      <th>ca</th>
      <th>thal</th>
      <th>target</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>300</th>
      <td>68</td>
      <td>1</td>
      <td>0</td>
      <td>144</td>
      <td>193</td>
      <td>1</td>
      <td>1</td>
      <td>141</td>
      <td>0</td>
      <td>3.4</td>
      <td>1</td>
      <td>2</td>
      <td>3</td>
      <td>0</td>
    </tr>
    <tr>
      <th>301</th>
      <td>57</td>
      <td>1</td>
      <td>0</td>
      <td>130</td>
      <td>131</td>
      <td>0</td>
      <td>1</td>
      <td>115</td>
      <td>1</td>
      <td>1.2</td>
      <td>1</td>
      <td>1</td>
      <td>3</td>
      <td>0</td>
    </tr>
    <tr>
      <th>302</th>
      <td>57</td>
      <td>0</td>
      <td>1</td>
      <td>130</td>
      <td>236</td>
      <td>0</td>
      <td>0</td>
      <td>174</td>
      <td>0</td>
      <td>0.0</td>
      <td>1</td>
      <td>1</td>
      <td>2</td>
      <td>0</td>
    </tr>
  </tbody>
</table>
</div>



Another method is **info** to see the columns and the type of values stored on them. In general, Pandas try to associate a numerical value when possible. However, it will revert into datatype **object** when mixed values are found.


```python
heart.info()
```

    <class 'pandas.core.frame.DataFrame'>
    RangeIndex: 303 entries, 0 to 302
    Data columns (total 14 columns):
     #   Column    Non-Null Count  Dtype  
    ---  ------    --------------  -----  
     0   age       303 non-null    int64  
     1   sex       303 non-null    int64  
     2   cp        303 non-null    int64  
     3   trestbps  303 non-null    int64  
     4   chol      303 non-null    int64  
     5   fbs       303 non-null    int64  
     6   restecg   303 non-null    int64  
     7   thalach   303 non-null    int64  
     8   exang     303 non-null    int64  
     9   oldpeak   303 non-null    float64
     10  slope     303 non-null    int64  
     11  ca        303 non-null    int64  
     12  thal      303 non-null    int64  
     13  target    303 non-null    int64  
    dtypes: float64(1), int64(13)
    memory usage: 33.3 KB


In this particular case, the table is rather clean, with all columns populated. It is often the case where some columns have missing data, we will deal with them in another example.

Another way to query the database and mask some of the results can be by using boolean operations. Let's see some examples


```python
# here we select all people with heart conditions and older than 50
#print(heart.isna)
only50 = heart.where(heart['age'] > 50)
print(only50.head())
#only people that has the condition has values, the other has NaN as entries
#NaN are not counted or used in statistical analysis of the data frame. 
count1=only50['age'].count()
count2=heart['age'].count()
print('Values with NoNaNs in only50 ',count1,' and in the whole database', count2)
only50real=only50.dropna()
print(only50real.head())
# we can delete all rows with NaN as

```

        age  sex   cp  trestbps   chol  fbs  restecg  thalach  exang  oldpeak  \
    0  63.0  1.0  3.0     145.0  233.0  1.0      0.0    150.0    0.0      2.3   
    1   NaN  NaN  NaN       NaN    NaN  NaN      NaN      NaN    NaN      NaN   
    2   NaN  NaN  NaN       NaN    NaN  NaN      NaN      NaN    NaN      NaN   
    3  56.0  1.0  1.0     120.0  236.0  0.0      1.0    178.0    0.0      0.8   
    4  57.0  0.0  0.0     120.0  354.0  0.0      1.0    163.0    1.0      0.6   
    
       slope   ca  thal  target  
    0    0.0  0.0   1.0     1.0  
    1    NaN  NaN   NaN     NaN  
    2    NaN  NaN   NaN     NaN  
    3    2.0  0.0   2.0     1.0  
    4    2.0  0.0   2.0     1.0  
    Values with NoNaNs in only50  208  and in the whole database 303
        age  sex   cp  trestbps   chol  fbs  restecg  thalach  exang  oldpeak  \
    0  63.0  1.0  3.0     145.0  233.0  1.0      0.0    150.0    0.0      2.3   
    3  56.0  1.0  1.0     120.0  236.0  0.0      1.0    178.0    0.0      0.8   
    4  57.0  0.0  0.0     120.0  354.0  0.0      1.0    163.0    1.0      0.6   
    5  57.0  1.0  0.0     140.0  192.0  0.0      1.0    148.0    0.0      0.4   
    6  56.0  0.0  1.0     140.0  294.0  0.0      0.0    153.0    0.0      1.3   
    
       slope   ca  thal  target  
    0    0.0  0.0   1.0     1.0  
    3    2.0  0.0   2.0     1.0  
    4    2.0  0.0   2.0     1.0  
    5    1.0  0.0   1.0     1.0  
    6    1.0  0.0   2.0     1.0  



```python
# we can avoid all this problem is we use
only50 = heart[heart['age']>50]
print(only50.head())
# but now we can do it more complex, for example, people older than 50 with cholesterol larger than 150
only50 = heart[(heart['age']>50) & (heart['chol'] > 150)]
```

       age  sex  cp  trestbps  chol  fbs  restecg  thalach  exang  oldpeak  slope  \
    0   63    1   3       145   233    1        0      150      0      2.3      0   
    3   56    1   1       120   236    0        1      178      0      0.8      2   
    4   57    0   0       120   354    0        1      163      1      0.6      2   
    5   57    1   0       140   192    0        1      148      0      0.4      1   
    6   56    0   1       140   294    0        0      153      0      1.3      1   
    
       ca  thal  target  
    0   0     1       1  
    3   0     2       1  
    4   0     2       1  
    5   0     1       1  
    6   0     2       1  



```python
#we can also order things promoting a column to be the index
heart1=heart.set_index('age')
print(heart1.head())
# we can also come back to the original index and move the existing index to a new column
heart1=heart1.reset_index()
print(heart1.head())
# for binary we can alw
```

         sex  cp  trestbps  chol  fbs  restecg  thalach  exang  oldpeak  slope  \
    age                                                                          
    63     1   3       145   233    1        0      150      0      2.3      0   
    37     1   2       130   250    0        1      187      0      3.5      0   
    41     0   1       130   204    0        0      172      0      1.4      2   
    56     1   1       120   236    0        1      178      0      0.8      2   
    57     0   0       120   354    0        1      163      1      0.6      2   
    
         ca  thal  target  
    age                    
    63    0     1       1  
    37    0     2       1  
    41    0     2       1  
    56    0     2       1  
    57    0     2       1  
       age  sex  cp  trestbps  chol  fbs  restecg  thalach  exang  oldpeak  slope  \
    0   63    1   3       145   233    1        0      150      0      2.3      0   
    1   37    1   2       130   250    0        1      187      0      3.5      0   
    2   41    0   1       130   204    0        0      172      0      1.4      2   
    3   56    1   1       120   236    0        1      178      0      0.8      2   
    4   57    0   0       120   354    0        1      163      1      0.6      2   
    
       ca  thal  target  
    0   0     1       1  
    1   0     2       1  
    2   0     2       1  
    3   0     2       1  
    4   0     2       1  



```python
# There is a cool idea in Pandas which is hierarchical indexes.. for example, 
case1 = pd.Series({'Date': '2020-05-01','Class': 'class 1','Value': 1})
case2 = pd.Series({'Date': '2020-05-01','Class': 'class 2','Value': 2})
case3 = pd.Series({'Date': '2020-05-02','Class': 'class 1','Value': 3})
case4 = pd.Series({'Date': '2020-05-03','Class': 'class 1','Value': 4})
case5 = pd.Series({'Date': '2020-05-03','Class': 'class 2','Value': 5})
case6 = pd.Series({'Date': '2020-05-04','Class': 'class 1','Value': 6})


df=pd.DataFrame([case1,case2,case3,case4,case5,case6])
print(df.head())

```

             Date    Class  Value
    0  2020-05-01  class 1      1
    1  2020-05-01  class 2      2
    2  2020-05-02  class 1      3
    3  2020-05-03  class 1      4
    4  2020-05-03  class 2      5



```python
df = df.set_index(['Date', 'Class'])
print(df.head())


```

                        Value
    Date       Class         
    2020-05-01 class 1      1
               class 2      2
    2020-05-02 class 1      3
    2020-05-03 class 1      4
               class 2      5


## Checking and removing duplicates

Another important check to perform on DataFrames is search for duplicated rows. Let's continue using the 'hearth' data frame and search duplicated rows.


```python
heart.duplicated()
```




    0      False
    1      False
    2      False
    3      False
    4      False
           ...  
    298    False
    299    False
    300    False
    301    False
    302    False
    Length: 303, dtype: bool



The answer is a pandas series indicating if the row is duplicated or not. Let's see the duplicates:


```python
heart[heart.duplicated(keep=False)]
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>age</th>
      <th>sex</th>
      <th>cp</th>
      <th>trestbps</th>
      <th>chol</th>
      <th>fbs</th>
      <th>restecg</th>
      <th>thalach</th>
      <th>exang</th>
      <th>oldpeak</th>
      <th>slope</th>
      <th>ca</th>
      <th>thal</th>
      <th>target</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>163</th>
      <td>38</td>
      <td>1</td>
      <td>2</td>
      <td>138</td>
      <td>175</td>
      <td>0</td>
      <td>1</td>
      <td>173</td>
      <td>0</td>
      <td>0.0</td>
      <td>2</td>
      <td>4</td>
      <td>2</td>
      <td>1</td>
    </tr>
    <tr>
      <th>164</th>
      <td>38</td>
      <td>1</td>
      <td>2</td>
      <td>138</td>
      <td>175</td>
      <td>0</td>
      <td>1</td>
      <td>173</td>
      <td>0</td>
      <td>0.0</td>
      <td>2</td>
      <td>4</td>
      <td>2</td>
      <td>1</td>
    </tr>
  </tbody>
</table>
</div>



Two contiguous rows are identical. Most likely a human mistake entering the values. We can create a new DataFrame with one of those rows removed


```python
heart_nodup = heart.drop_duplicates()

heart_nodup.shape
```




    (302, 14)



Compare with the original DataFrame:


```python
heart.shape
```




    (303, 14)



## Dataset Merging


```python
# There is a cool idea in Pandas which is hierarchical indexes.. for example, 
case1 = pd.Series({'Date': '2020-05-01','Class': 'class 1','Value': 1})
case2 = pd.Series({'Date': '2020-05-01','Class': 'class 2','Value': 2})
case3 = pd.Series({'Date': '2020-05-02','Class': 'class 1','Value': 3})
case4 = pd.Series({'Date': '2020-05-03','Class': 'class 1','Value': 4})
case5 = pd.Series({'Date': '2020-05-03','Class': 'class 2','Value': 5})
case6 = pd.Series({'Date': '2020-05-04','Class': 'class 1','Value': 6})


df=pd.DataFrame([case1,case2,case3,case4,case5,case6])
print(df.head())
```

             Date    Class  Value
    0  2020-05-01  class 1      1
    1  2020-05-01  class 2      2
    2  2020-05-02  class 1      3
    3  2020-05-03  class 1      4
    4  2020-05-03  class 2      5



```python
df['Book']=['book 1','book 2','book 3','book 4','book 5','book 6']
print(df.head())
```

             Date    Class  Value    Book
    0  2020-05-01  class 1      1  book 1
    1  2020-05-01  class 2      2  book 2
    2  2020-05-02  class 1      3  book 3
    3  2020-05-03  class 1      4  book 4
    4  2020-05-03  class 2      5  book 5



```python
# A different method use index as the criteria
newdf=df.reset_index()
newdf['New Book']=pd.Series({1:'New Book 1',4:'New Book 4'})
print(newdf.head())
```

       index        Date    Class  Value    Book    New Book
    0      0  2020-05-01  class 1      1  book 1         NaN
    1      1  2020-05-01  class 2      2  book 2  New Book 1
    2      2  2020-05-02  class 1      3  book 3         NaN
    3      3  2020-05-03  class 1      4  book 4         NaN
    4      4  2020-05-03  class 2      5  book 5  New Book 4



```python
# Let see how Merge works

```

## Plotting


```python
%matplotlib inline
heart['age'].plot.hist(bins=20);
```


    
![png]({{ page.root }}/fig/output_118_0.png)
    



```python
import seaborn as sns
```


```python
h4=heart[['age', 'trestbps', 'chol', 'thalach']]
goal=[ 'no heart disease' if x==1 else 'heart disease' for x in heart['target'] ]
h5=h4.join(pd.DataFrame(goal, columns=['goal']))
```


```python
import matplotlib.pyplot as plt

g = sns.PairGrid(h5, hue="goal")
g.map_diag(plt.hist)
g.map_offdiag(plt.scatter)
g.add_legend();
```


    
![png]({{ page.root }}/fig/output_121_0.png)
    


# Acknowledgments and References

This Notebook has been adapted by **Guillermo Avendaño** (WVU), **Jose Rogan** (Universidad de Chile) and **Aldo Humberto Romero** (WVU) from the [Tutorials for Stanford cs228 and cs231n](https://github.com/kuleshov/cs228-material). A large part of the info was also built from scratch. In turn, that material was adapted by [Volodymyr Kuleshov](http://web.stanford.edu/~kuleshov/) and [Isaac Caswell](https://symsys.stanford.edu/viewing/symsysaffiliate/21335) from the `CS231n` Python tutorial by Justin Johnson (http://cs231n.github.io/python-numpy-tutorial/). Another good resource, in particular, if you want to just look for an answer to specific questions is [planetpython.org](http:planetpython.org), in particular for data science.

Changes to the original tutorial include strict Python 3 formats and a split of the material to fit a series of lessons on Python Programming for WVU's faculty and graduate students.

The support of the National Science Foundation and the US Department of Energy under projects: DMREF-NSF 1434897, NSF OAC-1740111 and DOE DE-SC0016176 is recognized.

<div style="clear: both; display: table;">
<div style="border: none; float: left; width: 40%; padding: 10px">
<img src="fig/NSF.jpg" alt="National Science Foundation" style="width:50%" align="left">
    </div>
    <div style="border: none; float: right; width: 40%; padding: 10px">
<img src="fig/DOE.jpg" alt="National Science Foundation" style="width:50%" align="right">
</div>

# Back of the Book


```python
plt.figure(figsize=(3,3))
n = chapter_number
maxt=(2*(n-1)+3)*np.pi/2
t = np.linspace(np.pi/2, maxt, 1000)
tt= 1.0/(t+0.01)
x = (maxt-t)*np.cos(t)**3
y = t*np.sqrt(np.abs(np.cos(t))) + np.sin(0.3*t)*np.cos(2*t)
plt.plot(x, y, c="green")
plt.axis('off');
```


    
![png]({{ page.root }}/fig/output_124_0.png)
    



```python
end = time.time()
print(f'Chapter {chapter_number} run in {int(end - start):d} seconds')
```

    Chapter 7 run in 32 seconds
