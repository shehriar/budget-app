package com.example.backend.common;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.RequestBody;
import java.util.Map;

@RestController
public class NewSpendFormController {
    @GetMapping("/api/new-spend/validate-permission")
    public boolean validatePermission() {
        return true;
    }

    @PostMapping("/api/new-spend/submit-form")
    public void submitForm(@RequestBody Map<String, String> payload) {
        Map<String, String> value = payload;
        System.out.println(payload.get("form"));
    }
}
