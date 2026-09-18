<?php
require_once 'config/app.php';

$pageTitle = 'Civic Ballot | Private election voting';
$election = current_election();

include 'includes/header.php';
?>

<section class="hero">
    <div>
        <div class="eyebrow">Private election platform</div>

        <h1>A clearer way to make a collective decision.</h1>

        <p>
            Verified members cast one secret ballot in an election designed
            for associations, schools, parties, and organizations.
        </p>

        <a class="button" href="login.php">Verify and vote</a>
    </div>

    <aside class="hero-aside">
        <div class="eyebrow">Now open</div>

        <strong>
            <?= e($election['title'] ?? 'Community election') ?>
        </strong>

        <p>
            <?= e(
                $election['description']
                ?? 'A private election prototype with verifiable participation and anonymous ballots.'
            ) ?>
        </p>

        <a href="results.php">View public results &rarr;</a>
    </aside>
</section>

<section>
    <div class="section-heading">
        <h2>Built around trust</h2>
        <span class="label">Prototype safeguards</span>
    </div>

    <div class="grid">
        <div class="panel">
            <div class="stat">01</div>

            <h3>Verified access</h3>

            <p>
                Eligibility is checked before the ballot appears.
                This demo uses a placeholder check for a real identity provider.
            </p>
        </div>

        <div class="panel">
            <div class="stat">02</div>

            <h3>Secret ballot</h3>

            <p>
                Voting status and ballot choices live in separate records.
                Administrators see totals, never an identifiable choice.
            </p>
        </div>

        <div class="panel">
            <div class="stat">03</div>

            <h3>One submission</h3>

            <p>
                A transaction locks the voter status and records a receipt,
                preventing duplicate submissions.
            </p>
        </div>
    </div>
</section>

<?php include 'includes/footer.php'; ?>