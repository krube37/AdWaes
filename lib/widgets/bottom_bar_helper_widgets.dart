part of bottom_bar;

class _BottomBarColumn extends StatelessWidget {
  final String heading;
  final String s1;
  final String s2;
  final String s3;

  const _BottomBarColumn({
    super.key,
    required this.heading,
    required this.s1,
    required this.s2,
    required this.s3,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            heading,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            s1,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 14,
              //fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            s2,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 14,
              //fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            s3,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 14,
              //fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}

class _InfoText extends StatelessWidget {
  final String type;
  final String text;

  const _InfoText({
    super.key,
    required this.type,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$type: ',
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 16,
          ),
        ),
        Flexible(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 16,
            ),
          ),
        )
      ],
    );
  }
}
