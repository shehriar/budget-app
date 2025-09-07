package com.example.backend.common;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import java.util.Map;

@RestController
public class BudgetFormController {
    @GetMapping("/api/budget/budgetform")
    public Map<String, String> health() {
        return Map.of("status", "ok");
    }
}
