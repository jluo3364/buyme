package com.cs336.pkg;

import java.util.HashMap;
import java.util.Map;

public class CategoryDetails {
    private Map<String,Object> details;

    public CategoryDetails() {
        details = new HashMap<String,Object>();
    }

    public void addDetail(String key, Object value) {
        details.put(key, value);
    }

    Map<String, Object> getDetails(){
        return details;
    }

    public Object getDetail(String key){
        return details.get(key);
    }
}
