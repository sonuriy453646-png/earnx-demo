import 'package:flutter/material.dart';

void main() => runApp(const EarnXDemoApp());

class EarnXDemoApp extends StatelessWidget {
  const EarnXDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EarnX Demo',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        scaffoldBackgroundColor: const Color(0xfff7f7fb),
      ),
      home: const DemoShell(),
    );
  }
}

class DemoShell extends StatefulWidget {
  const DemoShell({super.key});
  @override State<DemoShell> createState() => _DemoShellState();
}

class _DemoShellState extends State<DemoShell> {
  int tab = 0;
  int coins = 1250;
  final List<String> history = ['Welcome bonus +1,250 coins'];

  void earn(int amount, String label) {
    setState(() {
      coins += amount;
      history.insert(0, '$label +$amount coins');
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Demo reward added: +$amount coins')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomePage(coins: coins, onEarn: earn),
      TasksPage(onEarn: earn),
      WalletPage(coins: coins, history: history),
      const ReferralPage(),
      const ProfilePage(),
    ];
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              color: Colors.amber.shade100,
              padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 12),
              child: const Text(
                'DEMO / NOT REAL MONEY • PRANK PROTOTYPE',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12),
              ),
            ),
            Expanded(child: pages[tab]),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: tab,
        onDestinationSelected: (i) => setState(() => tab = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.task_alt_outlined), selectedIcon: Icon(Icons.task_alt), label: 'Tasks'),
          NavigationDestination(icon: Icon(Icons.account_balance_wallet_outlined), selectedIcon: Icon(Icons.account_balance_wallet), label: 'Wallet'),
          NavigationDestination(icon: Icon(Icons.people_outline), selectedIcon: Icon(Icons.people), label: 'Refer'),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  final int coins;
  final void Function(int, String) onEarn;
  const HomePage({super.key, required this.coins, required this.onEarn});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        const Text('EarnX', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900)),
        const Text('Demo earning experience', style: TextStyle(color: Colors.black54)),
        const SizedBox(height: 18),
        _BalanceCard(coins: coins),
        const SizedBox(height: 16),
        _InfoCard(
          icon: Icons.warning_amber_rounded,
          title: 'This is only a demo',
          text: 'Coins and withdrawal amounts are fictional. No real money can be earned or withdrawn.',
        ),
        const SizedBox(height: 18),
        const Text('Quick actions', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(child: _ActionButton(icon: Icons.play_circle_outline, label: 'Demo task', onTap: () => onEarn(100, 'Demo task'))),
            const SizedBox(width: 10),
            Expanded(child: _ActionButton(icon: Icons.card_giftcard, label: 'Daily bonus', onTap: () => onEarn(50, 'Daily bonus'))),
          ],
        ),
      ],
    );
  }
}

class TasksPage extends StatelessWidget {
  final void Function(int, String) onEarn;
  const TasksPage({super.key, required this.onEarn});

  @override
  Widget build(BuildContext context) {
    final tasks = [
      ('Watch demo video', '100 coins', 100),
      ('Complete demo survey', '250 coins', 250),
      ('Daily check-in', '50 coins', 50),
    ];
    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        const Text('Demo Tasks', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900)),
        const SizedBox(height: 6),
        const Text('All rewards here are fictional.', style: TextStyle(color: Colors.black54)),
        const SizedBox(height: 14),
        ...tasks.map((t) => Card(
          child: ListTile(
            leading: const CircleAvatar(child: Icon(Icons.bolt)),
            title: Text(t.$1, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(t.$2),
            trailing: FilledButton(
              onPressed: () => onEarn(t.$3, t.$1),
              child: const Text('Do'),
            ),
          ),
        )),
      ],
    );
  }
}

class WalletPage extends StatelessWidget {
  final int coins;
  final List<String> history;
  const WalletPage({super.key, required this.coins, required this.history});

  @override
  Widget build(BuildContext context) {
    final rupees = (coins / 100).toStringAsFixed(2);
    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        const Text('Demo Wallet', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900)),
        const SizedBox(height: 14),
        _BalanceCard(coins: coins, rupeeText: '₹$rupees demo value'),
        const SizedBox(height: 14),
        SizedBox(
          height: 52,
          child: FilledButton.icon(
            onPressed: () => showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text('Demo withdrawal'),
                content: const Text('Withdrawal is disabled. This prototype has no real-money payout system.'),
                actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK'))],
              ),
            ),
            icon: const Icon(Icons.account_balance),
            label: const Text('DEMO WITHDRAWAL'),
          ),
        ),
        const SizedBox(height: 22),
        const Text('History', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ...history.map((h) => ListTile(
          leading: const Icon(Icons.history),
          title: Text(h),
          subtitle: const Text('Demo transaction'),
        )),
      ],
    );
  }
}

class ReferralPage extends StatelessWidget {
  const ReferralPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        const Text('Refer & Demo', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900)),
        const SizedBox(height: 12),
        _InfoCard(
          icon: Icons.people,
          title: 'Your demo code',
          text: 'EARNX-DEMO-1234',
        ),
        const SizedBox(height: 12),
        const ListTile(
          leading: Icon(Icons.group),
          title: Text('Demo referrals'),
          subtitle: Text('0 referrals • 0 fictional coins'),
        ),
      ],
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        const Text('Profile', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900)),
        const SizedBox(height: 18),
        const CircleAvatar(radius: 42, child: Icon(Icons.person, size: 42)),
        const SizedBox(height: 10),
        const Center(child: Text('Demo User', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
        const SizedBox(height: 18),
        const _InfoCard(
          icon: Icons.verified_user,
          title: 'Prototype status',
          text: 'Demo only. No real payments, KYC, or cash withdrawal are enabled.',
        ),
      ],
    );
  }
}

class _BalanceCard extends StatelessWidget {
  final int coins;
  final String? rupeeText;
  const _BalanceCard({required this.coins, this.rupeeText});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Demo balance', style: TextStyle(color: Colors.black54)),
            const SizedBox(height: 6),
            Text('$coins coins', style: const TextStyle(fontSize: 34, fontWeight: FontWeight.w900)),
            Text(rupeeText ?? 'Fictional demo balance', style: const TextStyle(color: Colors.black54)),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String text;
  const _InfoCard({required this.icon, required this.title, required this.text});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 28),
            const SizedBox(width: 12),
            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(text),
              ],
            )),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _ActionButton({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 95,
    child: Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(icon, size: 30),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        ]),
      ),
    ),
  );
}
