namespace DrMarchand.UniXyz;

public sealed record UniXyzCommand(string Id, string Intent);

public interface IUniXyzCommandGateway
{
    Task SubmitAsync(UniXyzCommand command, CancellationToken cancellationToken = default);
}

public sealed class UniXyzViewModel(IUniXyzCommandGateway gateway)
{
    public Task SubmitAsync(UniXyzCommand command, CancellationToken cancellationToken = default)
    {
        // Windows submits a command through the governed gateway; no direct authoritative mutation.
        return gateway.SubmitAsync(command, cancellationToken);
    }
}
