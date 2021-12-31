import Link from 'next/link';

function Footer() {
  return (
    <footer
      id="sticky-footer"
      className="flex-shrink-0 py-4 bg-light text-black-50"
    >
      <div className="container text-center">
        <small>
          LAC - actual version: 1.1.3 - source code on{' '}
          <Link href="https://github.com/steledama/lac" passHref>
            Github
          </Link>
        </small>
      </div>
    </footer>
  );
}

export default Footer;
