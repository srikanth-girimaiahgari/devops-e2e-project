package com.bandbooking.controllers;

import com.bandbooking.models.Booking;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class BookingController {

    @GetMapping("/booking")
    public String booking(Model model) {
        return "booking";
    }

    @PostMapping("/booking")
    public String bookBand(@RequestParam("date") String date, Model model) {
        model.addAttribute("message", "Band booked on " + date);
        return "booking";
    }
}
