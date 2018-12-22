package com.yuri.kotlin_native_sample

expect fun platformName(): String

fun createApplicationScreenMessage() : String {
    return "on ${platformName()}"
}


data class Model(val id: Int, val webformatURL: String)

data class Response(val hits: List<Model>)
