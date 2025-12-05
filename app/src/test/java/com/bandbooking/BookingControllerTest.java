package com.bandbooking;

import com.bandbooking.controllers.BookingController;
import org.junit.jupiter.api.Test;
import org.springframework.ui.Model;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.Mockito.mock;

public class BookingControllerTest {

    @Test
    public void testBookingPage() {
        BookingController controller = new BookingController();
        Model model = mock(Model.class);
        String viewName = controller.booking(model);
        assertEquals("booking", viewName);
    }

    @Test
    public void testBookBand() {
        BookingController controller = new BookingController();
        Model model = mock(Model.class);
        String date = "2024-10-25";
        String viewName = controller.bookBand(date, model);
        assertEquals("booking", viewName);
    }
}
