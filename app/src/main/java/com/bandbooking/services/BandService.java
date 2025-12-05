// src/main/java/com/bandbooking/services/BandService.java
package com.bandbooking.services;

import com.bandbooking.models.Band;
import java.util.ArrayList;
import java.util.List;
import org.springframework.stereotype.Service;

@Service

public class BandService {
    private final List<Band> bands = new ArrayList<>();

    // Registers a new band and adds it to the bands list
    public void save(Band band) {
        bands.add(band);
    }

    // Retrieves all registered bands
    public List<Band> getAllBands() {
        return bands;
    }
}
