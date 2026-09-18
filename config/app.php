<?php
declare(strict_types=1);

session_start();
date_default_timezone_set('Africa/Lagos');
require_once __DIR__ . '/database.php';

function e(string $value): string { return htmlspecialchars($value, ENT_QUOTES, 'UTF-8'); }
function current_election(): array
{
    $stmt = db()->query("SELECT * FROM elections WHERE status = 'open' ORDER BY opens_at DESC LIMIT 1");
    return $stmt->fetch() ?: [];
}
function require_voter(): void
{
    if (empty($_SESSION['voter_id']) || empty($_SESSION['election_id'])) {
        header('Location: login.php');
        exit;
    }
}
function require_admin(): void
{
    if (empty($_SESSION['is_admin'])) {
        header('Location: login.php');
        exit;
    }
}
if (str_contains(__DIR__, DIRECTORY_SEPARATOR . 'admin') && basename($_SERVER['SCRIPT_NAME'] ?? '') !== 'login.php') {
    require_admin();
}
function audit(string $event, ?string $reference = null): void
{
    $ipHash = hash('sha256', $_SERVER['REMOTE_ADDR'] ?? 'unknown');
    $stmt = db()->prepare('INSERT INTO audit_logs (actor_type, actor_reference, event_type, ip_hash) VALUES (?, ?, ?, ?)');
    $stmt->execute(['voter', $reference, $event, $ipHash]);
}
