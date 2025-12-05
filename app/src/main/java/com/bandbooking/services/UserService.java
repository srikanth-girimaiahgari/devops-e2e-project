// src/main/java/com/bandbooking/services/UserService.java
package com.bandbooking.services;

import com.bandbooking.models.User;
import java.util.HashMap;
import java.util.Map;
import org.springframework.stereotype.Service;

@Service
public class UserService {
    private final Map<String, User> users = new HashMap<>();

    // Registers a new user by storing them in the users map
    public boolean register(User user) {
        if (users.containsKey(user.getUsername())) {
            return false; // Username already exists
        }
        users.put(user.getUsername(), user);
        return true;
    }

    // Validates user login by checking stored username and password
    public boolean login(String username, String password) {
        User user = users.get(username);
        return user != null && user.getPassword().equals(password);
    }

    // Retrieves a user by username
    public User getUser(String username) {
        return users.get(username);
    }
}
