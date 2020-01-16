---
title:      Golang反解含有未知字段类型的JSON
layout:     post
category:   blog
tags:       [golang, json]
---

golang自带的json解析中，若是声明的字段类型和实际传入的类型不同，会报错。例如:

    type User struct {
        ID   int    `json:"id"`
        Name string `json:"name"`
    }

若是实际传入的`User.ID`是个`string`类型，golang会报错。一般情况下，可以通过在声明中添加json字段的类型说明来解决，例如

    type User struct {
        ID   int    `json:"id,string"`
        Name string `json:"name"`
    }

假设有这种情况，由于历史原因，`ID`字段可能会传入`string`或`int`(实际上，在json中是浮点数)，这时将`ID`字段声明为`string`是不行的，golang不会自动将`int`型的内容自动转换为`string`。需要手动做一次转换，例如：

    type userWrapper struct {
        ID   interface{} `json:"id"`
        Name string      `json:"name"`
    }

    type User struct {
        ID   string `json:"id"`
        Name string `json:"name"`
    }

    func (u *User) UnmarshalJSON(b []byte) (err error) {
        d := json.NewDecoder(strings.NewReader(string(b)))
        d.UseNumber()

        var uw userWrapper
        if err := d.Decode(&uw); err != nil {
            return err
        }

        u.Name = uw.Name
        u.Uid = fmt.Sprintf("%v", uw.Uid)
        return nil
    }

在上面的代码中，额外多做了一步`d.UseNumber()`。这样做是为了避免`Uid`被表示为科学计数法。