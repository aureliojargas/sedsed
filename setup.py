# https://packaging.python.org/tutorials/packaging-projects/

import re
import setuptools


def get_long_description():
    with open("README.md", "r") as file_:
        return file_.read()


def get_version():
    with open("sedsed.py", "r") as file_:
        match = re.search(r'(?m)^__version__ = "(.*?)"', file_.read())
        if match:
            return match.group(1)
        raise RuntimeError("Unable to find version string.")


setuptools.setup(
    name="sedsed",
    version=get_version(),
    author="Aurelio Jargas",
    author_email="aurelio@aurelio.net",
    description="Debugger and code formatter for sed scripts",
    long_description=get_long_description(),
    long_description_content_type="text/markdown",
    url="https://aurelio.net/projects/sedsed/",
    project_urls={
        "Bug Tracker": "https://github.com/aureliojargas/sedsed/issues",
        "Source Code": "https://github.com/aureliojargas/sedsed",
    },
    classifiers=[
        "Development Status :: 5 - Production/Stable",
        "Environment :: Console",
        "Intended Audience :: Developers",
        "License :: OSI Approved :: GNU General Public License v3 (GPLv3)",
        "Operating System :: OS Independent",
        "Programming Language :: Python :: 2",
        "Programming Language :: Python :: 2.7",
        "Programming Language :: Python :: 3",
        "Programming Language :: Python :: 3.4",
        "Programming Language :: Python :: 3.5",
        "Programming Language :: Python :: 3.6",
        "Programming Language :: Python :: 3.7",
        "Programming Language :: Python :: 3.8",
        "Programming Language :: Python",
        "Topic :: Software Development",
    ],
    license="GPLv3",  # https://github.com/pypa/pip/issues/6677
    py_modules=["sedsed"],
    python_requires=">=2.7, !=3.0.*, !=3.1.*, !=3.2.*, !=3.3.*",
    install_requires="sedparse==0.1.*",
    entry_points={"console_scripts": ["sedsed = sedsed:entrypoint"]},
)
