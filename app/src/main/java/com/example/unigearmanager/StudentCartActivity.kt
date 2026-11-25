package com.example.unigearmanager

import android.content.Intent
import android.os.Bundle
import android.view.View
import android.widget.LinearLayout
import android.widget.ScrollView
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity

class StudentCartActivity : AppCompatActivity() {
    private var studentId: Int = 0
    private lateinit var studentName: String
    private lateinit var cartListContainer: LinearLayout

    private val repositoryChangeListener = {
        runOnUiThread {
            if (::cartListContainer.isInitialized) {
                renderCart()
            }
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        UniWearNotifier.ensureChannel(this)
        studentId = intent.getIntExtra("STUDENT_ID", 0)
        studentName = intent.getStringExtra("STUDENT_NAME")
            ?: UniWearRepository.getStudentName(studentId).takeIf { studentId in 1..10 }
            ?: "Student"
        setContentView(buildContent())
        renderCart()
    }

    override fun onStart() {
        super.onStart()
        UniWearRepository.addChangeListener(repositoryChangeListener)
    }

    override fun onStop() {
        UniWearRepository.removeChangeListener(repositoryChangeListener)
        super.onStop()
    }

    private fun buildContent(): View {
        return ScrollView(this).apply {
            setBackgroundResource(R.drawable.bg_scrapbook)
            addView(screenRoot().apply {
                addView(poster().apply {
                    addView(titleTab("My Cart"))
                    addView(label("Review your selected campus gear before placing an order.", size = 14f).apply {
                        setBackgroundResource(R.drawable.bg_note)
                        setPadding(dp(12), dp(12), dp(12), dp(12))
                    }.withMargins(top = 14))

                    addView(primaryButton("Back to Dashboard", red = false).withMargins(top = 12).apply {
                        setOnClickListener {
                            startActivity(Intent(this@StudentCartActivity, StudentDashboardActivity::class.java).apply {
                                putExtra("STUDENT_ID", studentId)
                                putExtra("STUDENT_NAME", studentName)
                            })
                            finish()
                        }
                    })
                    addView(primaryButton("Continue Shopping", red = false).withMargins(top = 10).apply {
                        setOnClickListener {
                            startActivity(Intent(this@StudentCartActivity, StudentStoreActivity::class.java).apply {
                                putExtra("STUDENT_ID", studentId)
                                putExtra("STUDENT_NAME", studentName)
                            })
                            finish()
                        }
                    })

                    addView(label("Cart Items", size = 18f, bold = true).withMargins(top = 16))
                    cartListContainer = LinearLayout(this@StudentCartActivity).apply {
                        orientation = LinearLayout.VERTICAL
                    }
                    addView(cartListContainer)
                })
            })
        }
    }

    private fun renderCart() {
        cartListContainer.removeAllViews()
        val cartItems = UniWearRepository.getCartForStudent(studentName)
        if (cartItems.isEmpty()) {
            cartListContainer.addView(card().apply {
                addView(label("Your cart is empty.", size = 14f, bold = true))
                addView(label("Use Order Campus Gear to add items.", size = 13f))
            }.withMargins(top = 10))
            return
        }

        cartItems.forEach { cartItem ->
            cartListContainer.addView(cartItemCard(cartItem))
        }
    }

    private fun cartItemCard(cartItem: CartItem): LinearLayout {
        val item = UniWearRepository.itemById(cartItem.itemId)
        val stockText = if (item == null) {
            "Item no longer available"
        } else {
            "${item.stock} ${item.unit} available"
        }

        return card().apply {
            addView(label(cartItem.itemName, size = 17f, bold = true))
            cartItem.size?.let { addView(label("Size: $it", size = 13f)) }
            addView(label("Qty: ${cartItem.quantity} | Total: ${formatPeso(cartItem.total)}", size = 13f))
            addView(label(stockText, size = 13f))
            addView(primaryButton("Place Order", red = true).withMargins(top = 10).apply {
                isEnabled = item != null && cartItem.quantity <= item.stock
                setOnClickListener {
                    placeCartOrder(cartItem)
                }
            })
            addView(primaryButton("Remove from Cart", red = false).withMargins(top = 8).apply {
                setOnClickListener {
                    UniWearRepository.removeCartItem(cartItem.id)
                    Toast.makeText(this@StudentCartActivity, "Removed from cart.", Toast.LENGTH_SHORT).show()
                }
            })
        }.withMargins(top = 12) as LinearLayout
    }

    private fun placeCartOrder(cartItem: CartItem) {
        val order = UniWearRepository.placeCartItemOrder(cartItem.id)
        if (order == null) {
            Toast.makeText(this, "Not enough stock to place this order.", Toast.LENGTH_SHORT).show()
            renderCart()
            return
        }

        val sizeText = order.size?.let { " ($it)" }.orEmpty()
        val message = "Order #${order.id} for ${order.itemName}$sizeText was submitted."
        UniWearNotifier.notifyStudent(this, order, "Order submitted", message)
        Toast.makeText(this, "Order submitted.", Toast.LENGTH_SHORT).show()
        renderCart()
    }

    private fun formatPeso(amount: Double): String = "PHP %.2f".format(amount)
}
