// src/main/java/com/bandbooking/controllers/BandController.java
package com.bandbooking.controllers;

import com.bandbooking.models.Band;
import com.bandbooking.services.BandService;
import javax.servlet.http.HttpServletRequest;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class BandController {
    private final BandService bandService;

    public BandController(BandService bandService) {
        this.bandService = bandService;
    }

    @GetMapping("/bands")
    public ModelAndView showBands() {
        ModelAndView modelAndView = new ModelAndView("home");
        modelAndView.addObject("bands", bandService.getAllBands());
        return modelAndView;
    }

    @PostMapping("/band_register")
    public String registerBand(HttpServletRequest request) {
        String name = request.getParameter("name");
        String ownerName = request.getParameter("ownerName");
        String contactNumber = request.getParameter("contactNumber");
        String address = request.getParameter("address");
        String image = request.getParameter("image");

        Band band = new Band();
        band.setName(name);
        band.setOwnerName(ownerName);
        band.setContactNumber(contactNumber);
        band.setAddress(address);
        band.setImage(image);
        bandService.save(band);
        return "redirect:/bands";
    }
}
