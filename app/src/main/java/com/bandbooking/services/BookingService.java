// src/main/java/com/bandbooking/services/BookingService.java
package com.bandbooking.services;

import com.bandbooking.models.Booking;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;
import org.springframework.stereotype.Service;

@Service

public class BookingService {
    private final List<Booking> bookings = new ArrayList<>();

    // Adds a new booking to the list
    public void save(Booking booking) {
        bookings.add(booking);
    }

    // Retrieves all bookings
    public List<Booking> getAllBookings() {
        return bookings;
    }

    // Retrieves bookings for a specific band
    public List<Booking> getBookingsByBandId(Long bandId) {
        return bookings.stream()
                .filter(booking -> booking.getBandId().equals(bandId))
                .collect(Collectors.toList());
    }

    // Checks if a specific date is available for booking
    public boolean isDateAvailable(Long bandId, String date) {
        return bookings.stream()
                .filter(booking -> booking.getBandId().equals(bandId))
                .noneMatch(booking -> booking.getDate().equals(date));
    }
}
