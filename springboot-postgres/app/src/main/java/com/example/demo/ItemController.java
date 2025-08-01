package com.example.demo;

import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/items")
public class ItemController {

    private final ItemRepository repo;

    public ItemController(ItemRepository repo) {
        this.repo = repo;
    }

    @GetMapping("/ping")
    public String ping() {
        return "pong";
    }
    @PostMapping
    public Item add(@RequestBody Item item) {
        return repo.save(item);
    }
}
