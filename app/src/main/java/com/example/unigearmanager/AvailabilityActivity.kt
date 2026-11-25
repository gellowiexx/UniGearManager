package com.example.unigearmanager

import android.os.Bundle
import android.widget.LinearLayout
import android.widget.TextView
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import com.google.android.material.button.MaterialButton
import com.example.unigearmanager.*

class AvailabilityActivity : AppCompatActivity() {
    private lateinit var availableListContainer: LinearLayout
    private lateinit var unavailableListContainer: LinearLayout

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_availability)

        availableListContainer = findViewById(R.id.availableListContainer)
        unavailableListContainer = findViewById(R.id.unavailableListContainer)
        renderAvailability()

        findViewById<MaterialButton>(R.id.btnSendRestockAlert).setOnClickListener {
            val item = UniWearRepository.lowestStockItem()
            if (item == null) {
                Toast.makeText(this, "No inventory items to restock.", Toast.LENGTH_SHORT).show()
                return@setOnClickListener
            }

            UniWearRepository.restock(item)
            renderAvailability()
            Toast.makeText(this, "${item.name} restocked.", Toast.LENGTH_SHORT).show()
        }
    }

    override fun onResume() {
        super.onResume()
        renderAvailability()
    }

    private fun renderAvailability() {
        availableListContainer.removeAllViews()
        unavailableListContainer.removeAllViews()

        val availableItems = UniWearRepository.items.filter { it.stock > 0 }
        val unavailableItems = UniWearRepository.items.filter { it.stock <= 0 }

        if (availableItems.isEmpty()) {
            availableListContainer.addView(emptyCard("No available items right now."))
        } else {
            availableItems.forEach { item ->
                availableListContainer.addView(availabilityCard(item, available = true))
            }
        }

        if (unavailableItems.isEmpty()) {
            unavailableListContainer.addView(emptyCard("No unavailable items right now."))
        } else {
            unavailableItems.forEach { item ->
                unavailableListContainer.addView(availabilityCard(item, available = false))
            }
        }
    }

    private fun availabilityCard(item: GearItem, available: Boolean): TextView {
        return TextView(this).apply {
            text = "${item.name}\n${availabilityLabel(item)}"
            textSize = 17f
            gravity = android.view.Gravity.CENTER
            setTextColor(getColor(R.color.ink))
            setBackgroundResource(if (available) R.drawable.bg_feature_accent else R.drawable.bg_feature_accent_red)
            setPadding(dp(14), dp(14), dp(14), dp(14))
        }.withMargins(top = 10) as TextView
    }

    private fun emptyCard(message: String): TextView {
        return TextView(this).apply {
            text = message
            textSize = 14f
            setTextColor(getColor(R.color.muted))
            setBackgroundResource(R.drawable.bg_note)
            setPadding(dp(14), dp(14), dp(14), dp(14))
        }.withMargins(top = 10) as TextView
    }

    private fun availabilityLabel(item: GearItem): String {
        return if (item.stock > 0) {
            "${item.stock} ${item.unit} available"
        } else {
            "Unavailable"
        }
    }
}
