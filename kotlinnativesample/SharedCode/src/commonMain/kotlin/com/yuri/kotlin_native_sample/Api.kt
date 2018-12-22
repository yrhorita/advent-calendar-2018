package com.yuri.kotlin_native_sample

import io.ktor.client.*
import io.ktor.client.request.*
import io.ktor.http.*
import kotlinx.coroutines.*

internal expect val ApplicationDispatcher: CoroutineDispatcher

class ApplicationApi {
    private val client = HttpClient()

    var address = Url("https://pixabay.com/api/?key=key&image_type=photo&q=christmas&page=1")

    fun about(callback: (String) -> Unit) {
        GlobalScope.apply {
            launch(ApplicationDispatcher) {
                val result: String = client.get {
                    url(this@ApplicationApi.address.toString())
                }

                callback(result)
            }
        }
    }
}
