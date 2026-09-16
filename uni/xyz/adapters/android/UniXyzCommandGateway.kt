data class UniXyzCommand(val id: String, val intent: String)

interface UniXyzCommandGateway {
    suspend fun submit(command: UniXyzCommand)
}

class UniXyzViewModel(private val gateway: UniXyzCommandGateway) {
    suspend fun submit(command: UniXyzCommand) {
        // Android submits a command through the governed gateway; no direct authoritative mutation.
        gateway.submit(command)
    }
}
