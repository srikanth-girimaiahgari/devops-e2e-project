package com.bandbooking;

import com.bandbooking.controllers.HomeController;
import org.junit.jupiter.api.Test;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.Mockito.mock;

public class HomeControllerTest {

    @Test
    public void testHome() {
        HomeController controller = new HomeController();
        Model model = mock(Model.class);
        String viewName = controller.home(model);
        assertEquals("home", viewName);
    }
}
