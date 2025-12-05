// src/test/java/com/bandbooking/AuthControllerTest.java
package com.bandbooking;

import com.bandbooking.controllers.AuthController;
import com.bandbooking.models.User;
import com.bandbooking.services.UserService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.Mockito;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.mock.web.MockHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

public class AuthControllerTest {

    private AuthController controller;
    private UserService userService;
    private MockHttpServletRequest request;

    @BeforeEach
    public void setUp() {
        userService = mock(UserService.class); // Mock UserService
        controller = new AuthController(userService); // Pass mock to AuthController
        request = new MockHttpServletRequest(); // Create a mock HTTP request
    }

    @Test
    public void testShowRegistrationForm() {
        ModelAndView modelAndView = controller.showRegistrationForm();
        assertEquals("register", modelAndView.getViewName()); // Check if view name is correct
    }

    @Test
    public void testRegisterUser_Success() {
        when(userService.register(any(User.class))).thenReturn(true); // Mock successful registration

        request.setParameter("username", "testUser");
        request.setParameter("password", "password123");

        ModelAndView modelAndView = controller.registerUser(request);

        assertEquals("login", modelAndView.getViewName()); // Check if redirected to login
        assertEquals("Registration successful! Please login.", modelAndView.getModel().get("message"));
    }

    @Test
    public void testRegisterUser_Failure() {
        when(userService.register(any(User.class))).thenReturn(false); // Mock registration failure

        request.setParameter("username", "testUser");
        request.setParameter("password", "password123");

        ModelAndView modelAndView = controller.registerUser(request);

        assertEquals("register", modelAndView.getViewName()); // Check if redirected back to register
        assertEquals("Username already exists.", modelAndView.getModel().get("error"));
    }

    @Test
    public void testShowLoginForm() {
        ModelAndView modelAndView = controller.showLoginForm();
        assertEquals("login", modelAndView.getViewName()); // Check if view name is correct
    }

    @Test
    public void testLoginUser_Success() {
        when(userService.login("testUser", "password123")).thenReturn(true); // Mock successful login

        request.setParameter("username", "testUser");
        request.setParameter("password", "password123");

        ModelAndView modelAndView = controller.loginUser(request);

        assertEquals("redirect:/home", modelAndView.getViewName()); // Check redirection to home
        assertEquals("testUser", request.getSession().getAttribute("user")); // Check if user is set in session
    }

    @Test
    public void testLoginUser_Failure() {
        when(userService.login("testUser", "wrongPassword")).thenReturn(false); // Mock login failure

        request.setParameter("username", "testUser");
        request.setParameter("password", "wrongPassword");

        ModelAndView modelAndView = controller.loginUser(request);

        assertEquals("login", modelAndView.getViewName()); // Check if redirected back to login
        assertEquals("Invalid username or password.", modelAndView.getModel().get("error"));
    }
}
