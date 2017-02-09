package com.example.guestbook;

import com.googlecode.objectify.Key;
import com.googlecode.objectify.annotation.Entity;
import com.googlecode.objectify.annotation.Id;
import com.googlecode.objectify.annotation.Index;
import com.googlecode.objectify.annotation.Parent;

import java.util.Date;

@Entity
public class Mission {
    @Parent private Key<DroneOwner> owner;
    @Id private Long id;

    @Index private Date date;
    private String data;
    
    Mission(){
        date = new Date();
    }

    Mission(DroneOwner o, Date d){
        date = d;
        owner = Key.create(DroneOwner.class, o.getName());
    }

    public void setData(String data){
        this.data = data;
    }
    
    public String getData(){
        return data;
    }

    public Date getDate(){
        return date;
    }

    public Long getId(){
        return id;
    }
}
    
