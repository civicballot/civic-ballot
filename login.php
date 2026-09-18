<?php
require_once 'config/app.php';
$pageTitle = 'Verify your eligibility';
$error = null;
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $reference = trim($_POST['voter_reference'] ?? '');
    $pvc = trim($_POST['pvc_reference'] ?? '');
    $election = current_election();
    if ($reference === '' || $pvc === '' || !$election) {
        $error = 'Enter both verification details. The election must also be open.';
    } else {
        $stmt = db()->prepare('SELECT * FROM voters WHERE voter_reference = ? AND pvc_reference = ? LIMIT 1');
        $stmt->execute([$reference, $pvc]);
        $voter = $stmt->fetch();
        if (!$voter) {
            $error = 'We could not verify those details. Check them and try again.';
        } else {
            $status = db()->prepare('SELECT has_voted FROM voter_election_status WHERE voter_id = ? AND election_id = ?');
            $status->execute([$voter['id'], $election['id']]);
            if ((int) $status->fetchColumn() === 1) {
                $error = 'Our records show this voter has already cast a ballot in this election.';
            } else {
                $_SESSION['voter_id'] = $voter['id']; $_SESSION['voter_name'] = $voter['full_name']; $_SESSION['election_id'] = $election['id'];
                audit('verification_success', $voter['voter_reference']); header('Location: vote.php'); exit;
            }
        }
    }
}
include 'includes/header.php';
?><div class="form-wrap"><div class="eyebrow">Step 01 / verification</div><h1>Confirm you are eligible to vote.</h1><p>For this prototype, enter the reference and PVC details supplied by the election administrator.</p><div class="notice"><strong>Demo boundary</strong><br>This screen is a placeholder for an authorized identity provider. Do not enter a real NIN.</div><?php if ($error): ?><div class="notice"><?= e($error) ?></div><?php endif; ?><form method="post"><div class="field"><label for="voter_reference">Voter reference</label><input id="voter_reference" name="voter_reference" placeholder="e.g. VOTER-78291" required></div><div class="field"><label for="pvc_reference">PVC / member ID</label><input id="pvc_reference" name="pvc_reference" placeholder="e.g. PVC-2026-0042" required></div><button class="button" type="submit">Continue to ballot &rarr;</button></form></div><?php include 'includes/footer.php'; ?>