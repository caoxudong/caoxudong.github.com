---
title:      "PDO: bindValue vs. bindParam"
category:   blog
layout:     post
tags:       [pdo, php]
---


在使用PDO的时候，经常会使用`bingParam`或者`bindValue`方法进行参数绑定。(对这两个方法的描述参见官方文档，[bingValue][1] vs. [bindParam][2])

正如文档中描述的，这两个方法最重要的区别在于，`binParam`方法的参数绑定是在调用`PDOStatement::execute()`方法才完成的。

> Binds a PHP variable to a corresponding named or question mark placeholder in the SQL statement that was used to prepare the statement. Unlike [PDOStatement::bindValue()][1], the variable is bound as a reference and will only be evaluated at the time that [PDOStatement::execute()][3] is called.

因此，如果在使用`bindParam`方法进行绑定后，并在调用`PDOStatement::execute()`方法之前，修改了变量值，则先前的绑定会失效。例如：

    private function bingParam($stmt, $config_name, $config) {
        $stmt->bingParam(':config_name', $config_name);
            foreach ($config as $key => $value) {
                $temp_key = ':content_'.$key;
                $stmt->bingParam($temp_key, $value);
            }   
        }   
    }
    

在上面的方法中，本意是遍历对象属性进行参数绑定，但由于使用了`bindParam`方法，因此，实际绑定的参数值都是最后一个属性值，导致最终赋值错误。

针对这种情况可以用`bindValue`方法完成所需功能。

[1]:    http://php.net/manual/en/pdostatement.bindvalue.php
[2]:    http://php.net/manual/en/pdostatement.bindparam.php
[3]:    http://www.php.net/manual/en/pdostatement.execute.php
